module ServicesHelper

  def service_nav(svc, style: '')
    raw <<-ERB
    <li style='background: ##{svc.color}; #{style}'>
      #{svc.name}
    </li>
    ERB
  end

  def svc_par_nav(svc, style: '')
    raw <<-ERB
    <li style='background: ##{svc.color}; #{style}'>
      <img class='icon' src='#{svc.team.icon_path}'/>
      #{svc.name}
    </li>
    ERB
  end


  def nav_to_unless_active(label, path, style: '')
    klas = current_page?(path) ? "class='disabled'" : ''
    raw <<-ERB
    <li #{klas}>
      <a href='#{path}' style='#{style}'>#{label}</a>
    </li>
    ERB
  end


  def partner_nav_to_unless_active(service, path, style: '')
    klas = current_page?(path) ? "class='disabled'" : ''
    label = <<-ERB
      <img class='icon' src='#{service.team.icon_path}'/>
      #{service.name}
    ERB
    raw <<-ERB
    <li #{klas}>
      <a href='#{path}' style='#{style}'>#{label}</a>
    </li>
    ERB
  end

  def report_link_for(report)
    raw <<-ERB
      <li>
        <a href="/reps/#{report.id_plus_query}"
           style="padding-top: 4px; padding-bottom: 4px;"
           target="_blank">#{report.name}</a>
      </li>
    ERB
  end

  # ----- /admin/service_types -----

  def service_type_helper
    base = '<option value=''></option>'
    vals = current_team.service_types.sorted.map do |typ|
      next if typ.name.blank?
      "<option value='#{typ.id}'>#{typ.name}</option>"
    end.select {|item| item.present?}
    raw base + vals.join
  end

  # ----- /admin/service_partners -----

  def partner_unsubscribe_button(service_partnership)
    url = "/admin/service_partners/#{service_partnership.id}"
    cls = 'btn btn-xs btn-danger'
    link_to 'Unsubscribe', url, :method => :delete, :confirm => 'Are you sure?', :class => cls
  end

  # ----- /services -----

  def svc_breadcrumb(path, labels, params = '')
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

  # ----- /services/:service_id/resrc (assignments)-----

  def participant_name(participant)
    return 'TBA' if participant.blank?
    <<-EOF
      <a href='/members/#{participant.user_name}' target='_blank'>
        #{participant.full_name}
      </a>
    EOF
  end

  def three_state_status(avail)
    arr = case avail.status
            when 'available'   then ['active', '']
            when 'unavailable' then ['', 'active']
            else ['', '']
          end
    ack, uck = arr
    <<-HTML
    <div class='btn-group'>
      <button id="avail_#{avail.id}" data-pk='#{avail.id}' class="avail btn btn-default btn-xs #{ack}">available</button>
      <button id="unava_#{avail.id}" data-pk='#{avail.id}' class="unava btn btn-default btn-xs #{uck}">unavailable</button>
    </div>
    HTML
  end

  def is_current_quarter(quarter)
    now = {year: Time.now.current_year, quarter: Time.now.current_quarter}
    quarter.slice(:year, :quarter) == now
  end

  def not_current_quarter(quarter)
    ! is_current_quarter(quarter)
  end

  def currlnk(quarter)
    q = quarter
    "?year=#{q[:year]}&quarter=#{q[:quarter]}"
  end

  def prevlnk(quarter, tab = nil)
    q = prevq(quarter)
    t = tab.nil? ? '' : "&tab=#{tab}"
    "?year=#{q[:year]}&quarter=#{q[:quarter]}#{t}"
  end

  def nextlnk(quarter, tab = nil)
    q = nextq(quarter)
    t = tab.nil? ? '' : "&tab=#{tab}"
    "?year=#{q[:year]}&quarter=#{q[:quarter]}#{t}"
  end

  def homelnk(tab = nil)
    t = tab.nil? ? '' : "&tab=#{tab}"
    "?year=#{Time.now.current_year}&quarter=#{Time.now.current_quarter}#{t}"
  end

  def prevq(quarter)
    y, q = case quarter[:quarter]
             when 2,3,4 then [quarter[:year], quarter[:quarter] - 1]
             else [quarter[:year] - 1, 4]
           end
    {year: y, quarter: q}
  end

  def nextq(quarter)
    y, q = case quarter[:quarter]
             when 1, 2, 3 then [quarter[:year], quarter[:quarter] + 1]
             else [quarter[:year] + 1, 1]
           end
    {year: y, quarter: q}
  end



end
