class Org::MembersController < ApplicationController

  before_action   :authenticate_owner!
  before_action   :validate_enterprise_org!
  before_action   :validate_support_team!

  def index
    @team    = Team.find_by_acronym(params[:team_id])
    @members = @team.memberships
  end

  def update
    id    = params[:id]
    name  = params[:name]
    value = params[:value]
    member = current_team.memberships.find(id)
    member.send "#{name}=", value || []
    member.save
    render partial: 'registry_row', locals: {mem: member}, layout: false
  end

  def role_one
    tgt_role = params[:id]
    remove_all_from_role(tgt_role)
    add_role_to_member(params[:value], tgt_role)
    render text: 'OK'
  end

  def role_many
    tgt_role = params[:id]
    remove_all_from_role(tgt_role)
    unless params[:value].blank?
      params[:value].each do |val|
        add_role_to_member(val, tgt_role)
      end
    end
    render text: 'OK'
  end

  private

  def add_role_to_member(member_id, tgt_role)
    tgt_memb = current_team.memberships.find(member_id)
    return if tgt_memb.nil?
    tgt_roles = tgt_memb.roles + [tgt_role]
    tgt_memb.roles = tgt_roles
    tgt_memb.save
  end

  def remove_all_from_role(tgt_role)
    curr_memb = current_team.memberships.where('? = ANY(roles)', tgt_role)
    curr_memb.to_a.each do |memb|
      new_roles = memb.roles.select { |role| role != tgt_role }
      memb.roles = new_roles
      memb.save
    end
  end

end
