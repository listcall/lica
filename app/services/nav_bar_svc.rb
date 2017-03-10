class NavBarSvc

  def self.feature_enabled(team, key)
    return true if %w(Lica_Team Lica_Members).include? key.to_s
    return true if key.split('_').first != 'Lica'
    team.team_features[key.to_s].try(:status) == 'on'
  end

  # ----- renders the header nav -----

  def self.header_nav(user, team, req_path)
    @mem = team.memberships.where(user_id: user.id).to_a.try(:first)
    return '' if @mem.nil?
    mem_rights = @mem.rights
    nav_link = ->(nav) do
      target = nav.path.match(/^http/) ? " target='_blank'" : ''
      act_klas = nav.path == req_path ? 'active hNav' : 'hNav'
      "<li class='#{act_klas}'><a #{act_klas} href='#{nav.path}' #{target}>#{nav.label}</a></li>"
    end
    can_see  = ->(nav) { nav.nil? ? false : nav.send(mem_rights) == 'show' }
    team.team_nav_hdrs.to_a.reduce('') do |acc, nav|
      acc << nav_link.call(nav) if can_see.call(nav) && feature_enabled(team, nav.type)
      acc
    end
  end

  # ----- renders the footer nav -----

  def self.footer_nav(user, team)
    return '' if user.nil?
    @mem = team.memberships.where(user_id: user.id).to_a.try(:first)
    return '' if @mem.nil?
    mem_rights = @mem.rights
    nav_link = ->(nav) do
      target = nav.path.match(/^http/) ? " target='_blank'" : ''
      "<a href='#{nav.path}'#{target}>#{nav.label}</a>"
    end
    can_see  = ->(nav) { nav.send(mem_rights) == 'show' }
    links = team.team_nav_ftrs.to_a.map do |nav|
      nav_link.call(nav) if can_see.call(nav) && feature_enabled(team, nav.type)
    end.select {|x| ! x.nil?}
    links.join(' | ')
  end

  # ----- renders the home-page nav -----
  def self.home_nav(user, team)
    @mem = team.memberships.where(user_id: user.id).to_a.try(:first)
    return '' if @mem.nil?
    mem_rights = @mem.rights
    nav_link = ->(nav) do
      target = nav.path.match(/^http/) ? " target='_blank'" : ''
      "<li><a href='#{nav.path}' #{target}>#{nav.label}</a></li>"
    end
    can_see  = ->(nav) { nav.nil? ? false : nav.send(mem_rights) == 'show' }
    team.team_nav_homes.to_a.reduce('') do |acc, nav|
      acc << nav_link.call(nav) if can_see.call(nav) && feature_enabled(team, nav.type)
      acc
    end
  end

  # ----- generates cross-team navigation in the header pulldown -----

  def self.team_nav(user, team, env)
    teams = user.teams.includes(:org).select {|t| t != team }
    team_links = teams.map { |team| team_link(team, env) }
    team_links.blank? ? '' : team_links.join
    sorted = prep_sort(teams)
    result = gen_sort(sorted, env)
    result
  end

  private

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

  def self.team_path(team, env)
    port = env['SERVER_PORT'].blank? ? '' : ":#{env["SERVER_PORT"]}"
    port = '' if Rails.env.production?
    base = "#{team.subdomain}.#{team.org.try(:domain)}".gsub(/^account./,'')
    "#{base}#{port}"
  end

  def self.prep_sort(teams)
    teams.reduce({}) do |ac, team|
      name = team.org.name
      unless ac[name]
        ac[name]                = {}
        ac[name]['type']        = team.org.typ
        ac[name]['field_teams'] = []
      end
      if team.typ == 'support'
        ac[name]['org_team'] = team
      else
        ac[name]['field_teams'] << team
      end
      ac
    end
  end

  def self.gen_sort(hash, env)
    div = "<li class='divider'></li>"
    hashes = hash.values.sort {|a,b| b['type'] <=> a['type'] }
    team_links = hashes.map do |hash|
      teams = hash['org_team'].nil? ? [] : [hash['org_team']]
      teams = teams + hash['field_teams'].sort {|a,b| a.acronym <=> b.acronym}
      links = teams.map do |team|
        team_link(team, env)
      end.join
      #links
    end.join(div)
    team_links.blank? ? '' : div + team_links + div
  end

end

