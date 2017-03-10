class TeamFeaturesSvc

  def initialize(current_team)
    @current_team = current_team
  end

  def add_obj(feature)
    features = @current_team.team_features
    features.add_obj feature
    @current_team.team_features = features
    @current_team.save
  end

  def updatez
    np = {id: params[:id], name: params[:name], value: params[:value]}
    TeamNavsSvc.new(current_team, params['pk']).update(np)
    current_team.reload
    nav = current_team.send("team_navs_#{params['pk']}")[params[:id]]
    render partial: 'nav_row', locals: {nav: nav}, layout: false
  end

  def update(params)
    id = params['id']
    name = params['name']
    feature = @current_team.team_features[id]
    return if feature.nil?
    feature.send("#{name}=", params['value'])
    features = @current_team.team_features
    features.destroy id
    features.add_obj feature
    @current_team.team_features = features
    @current_team.save
  end

  def update_old(params)
    id = params['id']
    name = params['name']
    feature = @current_team.team_features[id]
    return if feature.nil?
    feature.send("#{name}=", params['value'])
    features = @current_team.team_features
    features.destroy id
    features.add_obj feature
    @current_team.team_features = features
    @current_team.save
  end

  def destroy(params)
    if params[:id]
      features = current_team.team_features
      features.destroy params[:id]
      current_team.team_features = features
      current_team.save
    end
  end

end