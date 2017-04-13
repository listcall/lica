# new_serv

class Admin::PositionIndexController < ApplicationController

  before_action :authenticate_owner!

  def index
    @title     = 'Positions'
    @positions = current_team.positions
    @all_roles = current_team.roles
    @roles     = pickable_roles
  end

  def update
    name, value, cid = [params[:name], params[:value], params[:id]]
    position = current_team.positions.find(cid)
    position.update_attribute(name.to_sym, value)
    render plain: 'OK', layout: false
  end

  def create
    position  = Position.new params.permit(:team_role_id)
    position.team_id  = current_team.id
    position.sort_key = 0
    position.save
    render plain: 'OK'
  end

  def destroy
    position = Position.find params['id']
    position.try(:destroy)
    redirect_to '/admin/positions'
  end

  def sort
    positions = current_team.positions.to_a
    pos_hash  = positions.reduce({}) {|acc, val| acc[val.team_role.acronym] = val; acc}
    params['position'].each_with_index do |key, idx|
      pos_hash[key].update_attribute(:sort_key, idx + 1)
    end
    render plain: 'OK', layout: false
  end

  private

  def pickable_roles
    selected = current_team.positions.map {|pos| pos.team_role.try(:acronym)}
    current_team.roles.select {|x| ! selected.include?(x.acronym)}
  end
end
