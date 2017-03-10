module Admin::SvcIndexHelper
  def partner_lister
    raw <<-ERB
      <small>
        <a class='inline checkEditable' href='#' data-value='#{team_partner_acronyms}' data-name='partner_vals'>
          #{ team_partner_acronyms.join(', ') }
        </a>
      </small>
    ERB
  end

  def svc_partners(service)
    service.partners.map {|p| p.team.acronym}.sort
  end

  def team_partner_acronyms
    current_team.partners.map {|p| p.acronym}.sort
  end

  def team_partner_ids
    current_team.partners.map {|p| {text: p.acronym, value: p.id} }
  end
end