module AdminHelper

  def bclas(nav, type)
    act = nav.send(type) == 'show' ? ' btn-success' : ' btn-warning'
    "btn btn-xs btnRights#{act}"
  end

  def avatar_path(user, klas='smAvatar')
    return '' if user.nil?
    raw "<img class='#{klas}' src='#{user.avatar.url(:icon)}'/>"
  end

  def team_icon_path(member, klas='xsAvatar')
    user = member.try(:user)
    return '' if user.nil?
    raw "<img class='#{klas}' src='#{member.team.icon_path}'/>"
  end

  def rank_count(rank)
    @rank_count ||= {}
    @rank_count[rank.label] ||= current_team.memberships.where(rank: rank.label).count
  end

  def rank_delete_button(rank)
    if rank_count(rank) != 0
      link_to raw('<del>Delete</del>'), '#', :disabled => 'disabled', :class => 'btn btn-xs btn-disabled'
    else
      link_to 'Delete', "/admin/member_ranks/#{rank.id}", method: :delete, data: {confirm: 'Are you sure?'}, class: 'btn btn-xs btn-danger'
    end
  end

  def get_role_mems(role)
    @members.in_role(role.label)
  end

  def member_array
    current_team.memberships.includes(:user).active.by_last_name.to_a.map {|x| {value: x.id.to_s, text: x.full_name}}
  end

  def role_members(role)
    role_mems = get_role_mems(role)
    if role.has == 'one'
      single_role_widget(role, role_mems)
    else
      multi_role_widget(role, role_mems)
    end
  end

  def single_role_widget(role, role_mems)
    mem = role_mems.first
    len = role_mems.length - 1
    key = len > 0 ? " <small>+#{len}</small>" : ''
    val = mem.try(:id)
    "<a href='#' data-url='/admin/member_registry/role_one/#{role.label}' data-value='#{val}' class='xedit role-one'></a>#{key}"
  end

  def multi_role_widget(role, role_mems)
    data_val  = '<span style="color:white">.</span><i class="fa fa-edit"></i><span style="color:white">.</span>'
    badge     = "<span class='badge rankBadge'><a href='/admin/member_registry?roles=#{role.label}' target='_blank'> <i class='fa fa-group'></i> #{role_mems.count}</a></span>"
    edit_icon = "<a href='#' data-url='/admin/member_registry/role_many/#{role.label}' data-value='#{mem_array(role_mems)}' class='xedit role-many'>#{data_val}</a>"
    "#{badge} #{edit_icon}"
  end

  def mem_array(role_mems)
    role_mems.to_a.map {|mem| mem.id.to_s}
  end

  def member_delete_button(member)
    if member.sign_in_count != 0
      link_to raw('<del>Delete</del>'), '#', :disabled => 'disabled', :class => 'btn btn-xs btn-disabled'
    else
      link_to 'Delete', "/admin/member_drop/#{member.id}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-xs btn-danger'
    end
  end

  def role_delete_button(role)
    role_mems = get_role_mems(role)
    if role_mems.length != 0
      link_to raw('<del>Delete</del>'), '#', :disabled => 'disabled', :class => 'btn btn-xs btn-disabled'
    else
      link_to 'Delete', "/admin/member_roles/#{role.id}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-xs btn-danger'
    end
  end

  def event_role_delete_button(role)
    link_to 'Delete', "/admin/event_roles/#{role.id}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-xs btn-danger', 'data-pk' => "#{role.id}"
  end

  def member_attribute_delete_button(attribute)
    link_to 'Delete', "/admin/member_attributes/#{attribute.label}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-xs btn-danger'
  end

  def event_attribute_delete_button(attribute)
    link_to 'Delete', "/admin/event_attributes/#{attribute.label}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-xs btn-danger'
  end

  def navicon(type)
    raw "<i class='fa fa-#{type}' style='display: inline-block; width: 1.25em; text-align: center;'></i>"
  end

  def label_for(key)
    key.to_s.split('_').last.singularize.upcase
  end

  def current_section(menus)
    menu_paths = menus.values.map {|x| x[:path]}
    menu_paths.include?(request.path) ? 'in' : ''
  end

  def rights_helper(role)
    checked = ->(typ) { role.rights == typ ? ' checked' : '' }
    raw <<-ERB
    <div id="#{role.label}_rights"  class='make-switch switch-mini selectRights' data-on='warning' data-off='info' data-on-label=" <i class='fa fa-unlock'></i> adm " data-off-label=" <i class='fa fa-eye'></i> std ">
      <input type="checkbox"#{checked.call('owner')}>
    </div>
    ERB
  end

  def three_rights_helper(role)
    active = ->(typ) { role.rights == typ ? 'active' : '' }
    raw <<-ERB
      <div id='rights_#{role.id}' class="rightsGrp btn-group btn-group-xs" data-toggle="buttons">
        <label class="btn btn-default #{active.call('owner')}">
          <input id='admin_#{role.id}' class='rightsBtn' type="radio" name="opts"> owner
        </label>
        <label class="btn btn-default #{active.call('manager')}">
          <input id='director_#{role.id}' class='rightsBtn' type="radio" name="opts" > manager
        </label>
        <label class="btn btn-default  #{active.call('active')}">
          <input id='active_#{role.id}' class='rightsBtn' type="radio" name="opts" > active
        </label>
      </div>
    ERB
  end

  def has_helper(role)
    checked = ->(typ) { role.has == typ ? ' checked' : '' }
    raw <<-ERB
    <div id="#{role.id}_has" class='make-switch switch-mini selectHas' data-on='info' data-off='success' data-on-label="1" data-off-label="many">
      <input type="checkbox"#{checked.call('one')}>
    </div>
    ERB
  end

  def status_helper(feature)
    checked = ->(typ) { feature.status == typ ? ' checked' : '' }
    return raw '<b>always on</b>' if feature.label == 'Lica_Members'
    raw <<-ERB
    <div class='switch switch-mini' data-on='success' data-off='warning'>
      <input id='#{feature.label}' type="checkbox"#{checked.call('on')}>
    </div>
    ERB
  end

  def path_helper(nav, typ)
    return nav.path unless nav.type == '<custom>'
    <<-ERB
      <a class='inline' href='#' data-pk='#{typ}' data-url='/admin/team_navs/#{nav.id}' data-name='path'>
        #{nav.path}
      </a>
    ERB
  end

  def admin_header(type, page)
    left = "#{navicon(AdminOpts.menus[type][page][:icon])} <b>#{AdminOpts.menus[type][page][:title]}</b>"
    ltype = type.to_s.split('_').last.downcase
    right = <<-ERB
      <div style='float: right; display: inline-block; position: relative; padding-right: 10px; font-size: 12px;'>
        <span style='margin-right: 5px;'>#{AdminOpts.menus[type][page][:desc]}</span>
        #{admin_help_button("#{ltype}_#{AdminOpts.menus[type][page][:label]}")}
      </div>
    ERB
    raw "#{left}#{right}"
  end

  def admin_sub_header(type, page, sub_label)
    icon = "#{navicon(AdminOpts.menus[type][page][:icon])}"
    link = "<a href='#{AdminOpts.menus[type][page][:path]}'><b>#{AdminOpts.menus[type][page][:title]}</b></a>"
    raw "#{icon} #{link} > #{sub_label}"
  end

  def menu_group(key, menus)
    return '' unless feature_enabled(current_team, key)
    length = menus.count
    menval = visible_values(menus.values)
    menlnk = ->(menu) {"<a style='color: black;' href='#{menu[:path]}'>#{navicon(menu[:icon])} #{menu[:title]}"}
    mentds = ->(menu) {"<td class='sel'>#{menlnk.call(menu)}</td><td class='sel'>#{menu[:desc]}</td>"}
    header = "<td rowspan=#{length}>#{key.to_s.split('_').last.capitalize}</td>"
    head_row = "<tr>#{header}#{mentds.call(menval.first)}</tr>"
    tail_rows = menval[1..-1].map do |menu|
      "<tr>#{mentds.call(menu)}</tr>"
    end.join
    raw head_row + tail_rows
  end

  def partnership_delete_helper(partnership, msg = 'Delete')
      url = "/admin/team_partners/#{partnership.partner.id}"
      cls = 'btn btn-xs btn-danger'
      cnf = { confirm: 'Are you sure?'}
      raw link_to msg, url, method: :delete, data: cnf, class: cls
  end

end

