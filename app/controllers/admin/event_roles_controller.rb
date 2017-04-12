class Admin::EventRolesController < ApplicationController

  before_action :authenticate_owner!

  respond_to :html, :json

  def index
    @members = current_team.memberships
    @role  = EventRole.new
    @roles = current_team.event_roles.to_a
    respond_with @roles
  end

  def create
    @role  = EventRole.new(name: unique_name, acronym: unique_acronym, position: 0)
    if @role.valid?
      EventRolesSvc.new(current_team).add_obj(@role)
      redirect_to '/admin/event_roles', notice: "Added #{@role.acronym}"
    else
      redirect_to '/admin/event_roles', alert: 'There was an error creating the role...'
    end
  end

  def update
    EventRolesSvc.new(current_team).update(params)
    render :plain => 'OK'
  end

  def destroy
    EventRolesSvc.new(current_team).destroy(params)
    redirect_to '/admin/event_roles', :notice => "#{params[:id]} was deleted."
  end

  def sort
    EventRolesSvc.new(current_team).sort(params)
    render :plain => 'OK'
  end

  def list
    keys = current_team.event_roles.keys.map {|x| {value: x, text: x}}
    render json: keys.to_json, layout: false
  end

  private

  def unique_name
    unique_string current_team.event_roles.to_a.map {|x| x.name}
  end

  def unique_acronym
    unique_string current_team.event_roles.to_a.map {|x| x.acronym}
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
