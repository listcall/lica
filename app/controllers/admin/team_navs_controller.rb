class Admin::TeamNavsController < ApplicationController

  before_action :authenticate_owner!

  def show
    @title = 'Team Navbars'
    @hdr_navs  = enabled current_team.team_nav_hdrs.to_a
    @ftr_navs  = enabled current_team.team_nav_ftrs.to_a
    @home_navs = enabled current_team.team_nav_homes.to_a
  end

  def create
    @nav  = TeamNav.new
    if @nav.valid?
      TeamNavsSvc.new(current_team, params['typ']).add_obj(@nav)
      redirect_to "/admin/team_navs##{params['typ']}"
    else
      redirect_to "/admin/team_navs##{params['typ']}", alert: 'There was an error creating the nav...'
    end
  end

  def update
    np = {id: params[:id], name: params[:name], value: params[:value]}
    typ = params['pk'].strip
    TeamNavsSvc.new(current_team, typ).update(np)
    render plain: 'OK'
  end

  def destroy
    TeamNavsSvc.new(current_team, params['typ']).destroy(params[:id])
    redirect_to "/admin/team_navs##{params['typ']}"
  end

  def typelist
    pre_list = current_team.team_features.to_a.select {|x| x.status == 'on'}.map {|y| y.label}
    list = ['<custom>'] + pre_list.uniq.sort
    result = list.map do |x|
      {:text => x.split('_').last, :value => x}
    end
    render :json => result.to_json, :layout => false
  end

  def sort
    type = %w(hdrNavs ftrNavs homeNavs).find {|lbl| params[lbl]}
    list = params[type]
    TeamNavsSvc.new(current_team, type.gsub('Navs','')).sort(list)
    render :plain => 'OK'
  end

  private

  def enabled(list)
    list.select {|nav| feature_enabled(nav)}
  end

  def feature_enabled(nav)
    key = nav.to_h[:type]
    return true if %w(Lica_Team Lica_Members).include? key.to_s
    return true if key.split('_').first != 'Lica'
    current_team.team_features[key.to_s].try(:status) == 'on'
  end

end
