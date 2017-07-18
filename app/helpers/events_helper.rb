module EventsHelper

  def sdate(time)
    time.strftime('%b-%d')
  end

  def first_start
    current_team.events.ordered.first.try(:start).try(:strftime, '%b-%Y')
  end

  def last_finish
    current_team.events.ordered.last.try(:finish).try(:strftime, '%b-%Y')
  end

  def event_summary_stats
    tmp = current_team.event_types.to_a.map do |type|
      name = type.name
      type = type.id
      count = current_team.events.by_kind(type).count
      if name == 'Community'
        "#{count} Community"
      else
        "#{pluralize(count, name)}"
      end
    end
    "(#{tmp.join(', ')})"
  end

  def published_helper(event, type = 'new')
    checked = -> { event.published ? ' checked' : '' }
    raw <<-ERB
      <div id="publishedCheck" class="make-switch switch-mini" style="#{helper_style(type)}"  data-on-label="yes" data-off-label="no">
        <input id="pubChx" name="event[published]" type="checkbox" #{checked.call} />
      </div>
    ERB
  end

  def all_day_helper(event, type = 'new')
    checked = -> { event.all_day ? ' checked' : '' }
    raw <<-ERB
      <div id="allDayCheck" class="make-switch switch-mini" style="#{helper_style(type)}"  data-on-label="yes" data-off-label="no">
        <input id="dayChx" name="event[all_day]" type="checkbox" #{checked.call} />
      </div>
    ERB
  end

  def helper_style(type)
    case type
      when 'show' then 'margin-top: 0px; position: relative; top: -2px;'
      when 'new'  then 'display: block; width: 80px; margin-top: 8px;'
      else ''
    end
  end

  def event_delete_link(event)
    text, klas = if event.participants.count != 0
                   ['<del>Delete This Event</del>', 'disabled']
                 else
                   ['Delete This Event', '']
                 end
    url = "/events/#{event.id}"
    msg = {confirm: 'Are you sure?'}
    link_to raw(text), url, method: :delete, data: msg, class: "help-button #{klas}"
  end

  # ----- delete period button -----

  def participant_count(period)
    period.participants.count
  end

  def num_siblings(period)
    period.event.event_periods_count
  end

  def tooltip_text(period)
    count = period.participants.count
    return "no participants" if count == 0
    names = period.participants.map {|p| p.membership.last_name}.sort.join(", ")
    "#{count} participants: #{names}"
  end

  def delete_event_period_button(period)
    if period.participants.count != 0 || num_siblings(period) < 2
      cls = 'btn btn-xs btn-disabled'
      link_to raw('<del>Delete</del>'), '#', :disabled => 'disabled', :class => cls
    else
      url = "/events/#{period.event.event_ref}/periods/#{period.position}"
      msg = {confirm: 'Are you sure?'}
      cls = 'btn btn-xs btn-danger'
      link_to 'Delete', url, method: :delete, data: msg, class: cls
    end
  end

  def event_page_link(period, type)

    lbl  = type.to_s.upcase
    path = "/paging/new?pg_action=#{lbl}&pg_opid=#{period.id}"
    btyp = is_enabled?(period, type) ? "btn#{type.to_s.capitalize}" : ""
    dopt = is_enabled?(period, type) ? "" : "disabled='disabled'"
    clas = "btn btn-default #{btyp}"
    raw "<a target='_blank' #{dopt} class='#{clas}' href='#{path}'>#{lbl}</a>"
  end

  def is_enabled?(period, type)
    case type
      when :rsvp   then Time.now < period.event.finish && period.participants.has_left.count == 0
      when :notify then period.participants.count > 0
      when :leave  then period.participants.count > 0 && period.participants.has_not_left.count > 0
      when :return then period.participants.has_not_left.count == 0 && period.participants.has_not_returned.count > 0
      else true
    end
  end

  # ----- delete participant -----

  def delete_participant_button(participant)
    "<button id='eventPeriodDeleteBtn_<%= period.id %>' class='btn btn-xs btn-danger periodDel'>Delete</button>"
    url = "/ajax/periods/#{participant.period.id}/participants/#{participant.id}"
    msg = {confirm: 'Are you sure?'}
    cls = 'btn btn-xs btn-danger'
    link_to 'Delete', url, method: :delete, data: msg, class: cls
  end

  # ----- multi-team support -----

  def participating_teams_title(event)
    return '' if event.team.accepted_partnerships.blank?
    ext = (event.parent.nil? && event.is_childless?) ? ': NA' : ''
    "Partner Teams#{ext}"
  end

  def event_add_parent_button(event)
    return '' if event.team.accepted_partnerships.blank?
    return '' if  event.parent
    raw "<a href='#' style='border: 1px solid #ccc' class='inline btn btn-xs btn-default addParent'>Add Parent Team</a>"
  end

  def event_add_child_button(event)
    return '' if event.team.accepted_partnerships.blank?
    return '' if  event.has_children?
    raw "<a href='#' style='border: 1px solid #ccc' class='btn btn-xs btn-default addChild'>Add Child Team</a>"
  end

  def event_directory_button(event)
    return '' if  event.parent.nil? && event.is_childless?
    raw "<a href='#' class='btn btn-xs btn-default'>Event Directory</a>"
    ''
  end

  def parent_team(event)
    icon   = "<img class='xsAvatar' src='#{event.team.icon_path}'/>"
    change = "<a href='#' class='inline addParent'>Change</a>"
    remove = "<a href='#' class='inline inline_link delParent'>Remove</a>"
      #{icon} #{event.team.acronym} - #{event.title} (#{event.start.strftime("%b %-d")})
    html   = <<-ERB
      #{EventNavSvc.event_link(current_user, event, request.env)}
      <div style='float: right;'>
        #{change} | #{remove}
      </div>
    ERB
    raw html
  end

  def child_team(event)
    icon   = "<img class='xsAvatar' src='#{event.team.icon_path}'/>"
    remove = "<a href='#' data-evId='#{event.id}' class='inline inline_link delChild'>Remove</a>"
      #{icon} #{event.team.acronym} - #{event.title} (#{event.start.strftime("%b %-d")})
    html   = <<-ERB
    <div>
      #{EventNavSvc.event_link(current_user, event, request.env)}
      <div style='float: right;'>
        #{remove}
      </div>
    </div>
    ERB
    raw html
  end

  def child_periods(event)
    return '' if event.children.blank?
    raw <<-ERB
      <div style="margin-top: 5px;">
        <a id='childPeriodsModalLink' href="/events/#{event.event_ref}/periods" class='inline inline_link'>Child Periods</a>
      </div>
    ERB
  end

end
