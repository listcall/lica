class EventNavSvc

  # ----- generates cross-team navigation in the header pulldown -----

  def self.event_link(user, event, env)
    team = event.team
    url = "#{team_url(team, env)}/events/#{event.event_ref}"
    lbl = "#{team.acronym} - #{event.title} (#{event.start.strftime("%b %-d")})"
    out = if reserve_on(user, team)
      "<a href='#{url}' target='_blank'>#{lbl}</a>"
    else
      lbl
    end
    "#{team_icon(team)} #{out}"
  end

  private

  def self.reserve_on(user, team)
    mem = team.memberships.where(user_id: user.id).to_a.first
    return false unless mem
    %w(owner manager active reserve).include? mem.try(:rights)
  end

  def self.team_link(team, env)
    "<li><a href='#{team_url(team, env)}'>#{team_icon(team)} #{team.acronym}</a></li>"
  end

  def self.team_icon(team)
    path = team.icon_path
    "<img src='#{path}' class='icon'></img>"
  end

  def self.team_url(team, env)
    port = env['SERVER_PORT'].blank? ? '' : ":#{env["SERVER_PORT"]}"
    port = '' if Rails.env.production?
    orgd = calc_org_name(env['SERVER_NAME'])
    base = "#{team.subdomain}.#{orgd}".gsub(/^account./,'')
    "http://#{base}#{port}"
  end

  def self.calc_org_name(string)
    return string[/[^\.]\.(.*)/, 1] if string.count('.') == 2
    string
  end
end

