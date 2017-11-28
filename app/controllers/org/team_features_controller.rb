class Org::TeamFeaturesController < ApplicationController

  # before_action   :authenticate_member!
  before_action   :validate_enterprise_org!
  before_action   :validate_support_team!

  def index
    team = Team.find(params[:team_id])
    keys = team.team_features.keys
    vals = keys.reduce({}) do |ac, key|
      ac[key] = team.team_features[key].status
      ac
    end
    render plain: vals.to_json
  end

  def update
    team = Team.find params['team_id']
    feat = if params['status'] == 'RESET'
             feat = TeamFeatures.new
             feat.set_default_models!
             feat
           else
             features = team.team_features
             feature  = features[params['id']]
             feature.status = params['status']
             features
           end
    team.team_features = feat
    team.save
    render plain: 'OK'
  end
end