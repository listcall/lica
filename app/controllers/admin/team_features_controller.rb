class Admin::TeamFeaturesController < ApplicationController

  before_action :authenticate_owner!

  def show
    @title = 'Team Features'
    @features = current_team.team_features.to_a
  end

  def update
    features = current_team.team_features
    feature = params['feature']
    status  = params['turnTo']
    features[feature].status = status.downcase
    remove_nav(feature) if status.downcase == 'off'
    current_team.team_features = features
    current_team.save
    render text: 'OK'
  end

  private

  def ids(collection, feature)
    collection.to_a.select {|x| x.type == feature}.map {|y| y.id}
  end

  def remove_nav(feature)
    hdr     = current_team.team_nav_hdrs
    hdr_ids = ids(hdr, feature)
    hdr_ids.each {|x| hdr = hdr.destroy(x)}
    current_team.team_nav_hdrs = hdr
    ftr     = current_team.team_nav_ftrs
    ftr_ids = ids(ftr, feature)
    ftr_ids.each {|x| ftr = ftr.destroy(x)}
    current_team.team_nav_ftrs = ftr
  end
end
