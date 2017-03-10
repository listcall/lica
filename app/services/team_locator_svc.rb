class TeamLocatorSvc

  def self.find(domain, subdomain = '')
    if subdomain.empty?
      alt_team = Team.find_by_altdomain(domain)
      team = alt_team.nil? ? Org.find_by_domain(domain).try(:org_team) : alt_team
      [team.try(:org), team]
    else
      org = Org.find_by_domain(domain)
      return [nil, nil] if org.nil?
      [org, Team.where(subdomain: subdomain).where(org_id: org.id).first]
    end
  end

end