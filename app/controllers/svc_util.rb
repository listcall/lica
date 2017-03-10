module SvcUtil

  private

  def service_partner_setup
    svc_partners = Svc::Partner.where(team_id: current_team.id).sorted
    services = svc_partners.map { |partner| partner.svc }
  end

  def partner_service_ids
    Svc::Partner.where(team_id: current_team.id).sorted.pluck(:svc_id)
  end
end
