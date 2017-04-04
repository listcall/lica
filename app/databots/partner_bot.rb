class PartnerBot

  attr_reader :team

  def initialize(team)
    @team = team
  end

  def partner_list
    Team.not_partnered_with(team).map { |team| "#{team.acronym}" }.to_json
  end

  def full_partner_list
    Team.not_partnered_with(team).map do |team|
      {
        'value'     => "#{team.acronym} / #{team.name}".truncate(32),
        'tokens'    => [team.acronym, team.name],
        'team_id'   => team.id
      }
    end.to_json
  end

end