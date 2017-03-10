module PositionsHelper

  def pos_nav_link(pos)
    tgt = "/positions/#{pos.role.acronym}"
    cls = request.path == tgt ? "class='disabled'" : ''
    <<-HTML
    <li #{cls}>
    <a href='#{tgt}' style='padding-top: 4px; padding-bottom: 4px;'>
      #{pos.name}
    </a>
    </li>
    HTML
  end


  def position_partner_unsubscribe_button(position_partnership)
    url = "/admin/position_partners/#{position_partnership.id}"
    cls = 'btn btn-xs btn-danger'
    link_to 'Unsubscribe', url, :method => :delete, :confirm => 'Are you sure?', :class => cls
  end

  def member_names_in(role, team = current_team)
    mems = team.memberships.in_role(role.acronym)
    return 'TBA' if mems.blank?
    mems.map {|mem| mem.full_name}.join(', ')
  end

  def member_links_in(role, team = current_team)
    mems = team.memberships.in_role(role.acronym)
    return 'TBA' if mems.blank?
    result = mems.to_a.map do |mem|
      "<a target='_blank' href='/members/#{mem.user_name}'>#{mem.full_name}</a>"
    end
    raw result.join(' | ')
  end

  # ----- /services -----

  def pos_breadcrumb(path, labels, params = '')
    aop = Array(path); aol = Array(labels)
    result  = aol.map.with_index do |label, idx|
      if aop[idx]
        lpath = '/' + aop[0..idx].join('/') + params
        link_to(raw("<b>#{label}</b>"), lpath)
      else
        "<b>#{label}</b>"
      end
    end.join(' > ')
    raw result
  end

  # ----- /positions/:position_id/resrc (plan)-----

  # ----- body row -----

  def display_member_row(mem, position, quarter)
    memlink = "<a class='memlink' href='/positions/#{position.try(:id)}/schedule/#{mem.user_name}'>#{mem.last_name}</a>"
    part1   = "<tr class='memrow'>"
    part2   = "<td id='mem#{mem.id}' class='memlabel'><b class='memtag'>#{memlink}</b></td>"
    xopts   = quarter.merge({membership_id: mem.id, team_id: mem.team.id})
    part3   = 13.times.map do |week|
      yopts        = xopts.merge({week: week + 1})
      avail        = Avail::Week.find_or_create_by(yopts.except(:position_id))
      status       = get_status(avail)
      comment      = comment_helper(avail)
      select_class = select_helper(position, yopts)
      "<td id='#{cellid(yopts)}' #{comment} class='status#{select_class}'>#{status}</td>"
    end.join
    part4 = '</tr>'
    part1 + part2 + part3 + part4
  end

  # ---- header row -----

  def plan_header_cell(position, quarter, idx)
    ix = idx + 1
    quarter[:week] = ix
    start = position.weekly_start_for(quarter)
    finis = start + 1.week - 1.minute
    "<th id='week#{ix}' #{display_date_range(quarter, start, finis)}>W#{ix}</th>"
  end

  def display_date_range(quarter, start, finis)
    "data-weekid='#{quarter[:year]}-#{quarter[:quarter]}-#{quarter[:week]}' " +
      "data-toggle='tooltip' title='#{formatted(start)} - #{formatted(finis)}'"
  end

  def formatted(date)
    date.strftime('%b %d')
  end

  # -----

  def next_quarter(hash)
    lh = hash.clone
    if lh[:quarter] == 4
      lh[:year] += 1
      lh[:quarter] = 1
    else
      lh[:quarter] += 1
    end
    lh.delete(:week); lh.delete(:org_id)
    lh
  end

  def prev_quarter(hash)
    lh = hash.clone
    if lh[:quarter] == 1
      lh[:year] -= 1
      lh[:quarter] = 4
    else
      lh[:quarter] -= 1
    end
    lh.delete(:week); lh.delete(:org_id)
    lh
  end

  def link_prev(hash)
    link_to '<', do_assignments_path(prev_quarter(hash))
  end

  def link_next(hash)
    link_to '>', do_assignments_path(next_quarter(hash))
  end

  def link_current_quarter
    link_to 'Current Quarter', do_assignments_path
  end

  def avail_dos_link_prev(hash)
    link_to '<', member_avail_dos_path(prev_quarter(hash))
  end

  def avail_dos_link_next(hash)
    link_to '>', member_avail_dos_path(next_quarter(hash))
  end

  def this_quarter_number
    Time.now.current_quarter
  end

  def next_quarter_number
    current_quarter = Time.now.current_quarter
    current_quarter == 4 ? 1 : current_quarter + 1
  end

  def avail_dos_link_for_member(member, quarter)
    hash = {:member_id => member.id}.merge(quarter)
    link_to member.last_name, member_avail_dos_path(hash), :class => 'memlink'
  end

  def avail_dos_link_next_quarter(message)
    hash = {:member_id => current_member.id, :quarter => Time.now.current_quarter, :year => Time.now.year}
    link_to message, member_avail_dos_path(next_quarter(hash))
  end

  def avail_dos_link_current_quarter(hash)
    link_to 'Current Quarter', member_avail_dos_path(@current_member)
  end

  def edit_link_prev(hash)
    link_to '<', edit_do_assignment_path(prev_quarter(hash))
  end

  def edit_link_next(hash)
    link_to '>', edit_do_assignment_path(next_quarter(hash))
  end

  def edit_link_current_quarter
    link_to 'Current Quarter', edit_do_assignment_path
  end

  def plan_link_prev(hash)
    link_to '<', do_planner_path(prev_quarter(hash))
  end

  def plan_link_next(hash)
    link_to '>', do_planner_path(next_quarter(hash))
  end

  def plan_link_current_quarter
    link_to 'Current Quarter', do_planner_path
  end

  def get_status(avail)
    return '' if avail.blank?
    text = case avail.status
           when 'available'   then 'A'
           when 'unavailable' then '-'
           else ''
           end
    ftext = text == 'A' ? "<b>#{text}</b>" : text
    comment = avail.comment.blank? ? '' : '*'
    "#{ftext}#{comment}"
  end

  def cellid(opts)
    "#{opts[:year]}-#{opts[:quarter]}-#{opts[:week]}-#{opts[:membership_id]}-#{opts[:position_id]}"
  end

  def select_helper(position, opts)
    xopts = opts.slice(:year, :quarter, :week).merge({position_id: position.try(:id)})
    perio = Position::Period.where(xopts).first
    return '' if perio.blank?
    parti = perio.bookings.first
    return '' if parti.blank?
    return '' if parti.membership_id != opts[:membership_id]
    ' green'
  end

  def comment_helper(avail)
    return '' if avail.blank?
    return '' if avail.comment.blank?
    "data-toggle='tooltip' data-title='#{avail.comment}'"
  end

  def tabsel(typ)
    typ == @tab ? 'active' : ''
  end

  def position_assignment(participant)
    return 'TBA' if participant.blank?
    <<-EOF
      <a href='/members/#{participant.user_name}' target='_blank'>
        #{participant.full_name}
      </a>
    EOF
  end
end
