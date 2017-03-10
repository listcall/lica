# Public: Creates an org and a matching support team.
#
class OrgCreationSvc

  # Public: Create an AccountTeam and a matching Account.
  def self.create(name, domain, org_typ = 'enterprise')
    org = Org.where(name: name, domain: domain).to_a.first
    return org unless org.nil?
    org = Org.create(name: name, domain: domain, typ: org_typ)
    return org unless org && org.valid?
    args = {org_id: org.id, name: name, acronym: name, subdomain: 'account', typ: 'support', logo_text: name}
    org_team = Team.create(args)
    org.update_attributes(org_team_id: org_team.id)
    org
  end

end