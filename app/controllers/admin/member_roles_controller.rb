class Admin::MemberRolesController < ApplicationController

  before_action :authenticate_owner!

  respond_to :html, :json

  def index
    @members = current_team.memberships
    @role  = Team::Role.new
    @roles = current_team.roles.to_a
    respond_with @roles
  end

  def create
    @role  = Team::Role.new(name: unique_name, label: unique_label)
    if @role.valid?
      Team::RolesSvc.new(current_team).add(@role)
      redirect_to '/admin/member_roles', notice: "Added #{@role.label}"
    else
      redirect_to '/admin/member_roles', alert: 'There was an error creating the role...'
    end
  end

  def update
    Team::RolesSvc.new(current_team).update(params)
    render :text => 'OK'
  end

  def destroy
    Team::RolesSvc.new(current_team).destroy(params)
    redirect_to '/admin/member_roles', :notice => "#{params[:id]} was deleted."
  end

  def sort
    Team::RolesSvc.new(current_team).sort(params)
    render :text => 'OK'
  end

  def list
    keys = current_team.roles.map do |role|
      {value: role.acronym, text: "#{role.name} (#{role.acronym})"}
    end
    render text: keys.to_json, layout: false
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
