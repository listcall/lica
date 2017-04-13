class Admin::MemberRanksController < ApplicationController

  before_action :authenticate_owner!

  respond_to :html, :json

  def index
    @rank  = Team::Rank.new
    @ranks = current_team.ranks.to_a
    respond_with @ranks
  end

  def create
    @rank  = Team::Rank.new(name: unique_name, label: unique_label)
    if @rank.valid?
      Team::RanksSvc.new(current_team).add(@rank)
      redirect_to '/admin/member_ranks', notice: "Added #{@rank.label}"
    else
      redirect_to '/admin/member_ranks', alert: 'There was an error creating the rank...'
    end
  end

  def update
    Team::RanksSvc.new(current_team).update(params)
    render :plain => 'OK'
  end

  def destroy
    Team::RanksSvc.new(current_team).destroy(params)
    redirect_to '/admin/member_ranks', :notice => "#{params[:id]} was deleted."
  end

  def sort
    Team::RanksSvc.new(current_team).sort(params)
    render :plain => 'OK'
  end

  def list
    keys = current_team.ranks.map do |rank|
      {value: rank.acronym, text: "#{rank.name} (#{rank.acronym})"}
    end
    render json: keys.to_json, layout: false
  end

  private

  def unique_name
    unique_string current_team.roles.to_a.map {|x| x.name}
  end

  def unique_label
    unique_string current_team.roles.to_a.map {|x| x.label}
  end

  def unique_string(strings)
    return 'TBD' unless strings.include? 'TBD'
    idx = 1
    while (strings.include?("TBD#{idx}")) || idx > 100
      idx += 1
    end
    "TBD#{idx}"
  end
end
