class MembersController < ApplicationController

  before_action :authenticate_reserve!

  include MemberQry

  def index
    @member_records = member_records(current_team).to_json
    @page_title     = "#{current_team.acronym} members"
    
    # re-add this??
    #fresh_when etag: current_team, last_modified: current_team.updated_at, public: true
  end

  def show
    incl = [:user, :user => [:phones, :emails, :addresses, :emergency_contacts]]
    @member = current_team.memberships.includes(incl).by_id_or_user_name(params[:id]).first
    if @member.nil?
      redirect_to('/members', notice: notice_message(params[:id]))
    else
      @page_title    = " #{current_team.acronym} @#{@member.user_name}"
      @memid         = @member.id
      @user          = @member.user
      @phones        = @user.phones.all
      @emails        = @user.emails.all
      @addresses     = @user.addresses.all
      @contacts      = @user.emergency_contacts.all
      @editable      = @member == current_membership || owner_rights? # (admin_rights? && not_phone_device?)
      @ownerEditable = owner_rights?
    end
  end

  def photos
    @members    = current_team.users.all
    @page_title = "#{current_team.acronym} member photos"
  end

  def export
    @members    = current_team.users.all
    @page_title = "#{current_team.acronym} member export"
  end

  def destroy
    tgt_mem = Membership.find(params[:id])
    if view_context.can_delete(current_membership, tgt_mem)
      mem_name = tgt_mem.full_name
      tgt_mem.destroy
      redirect_to('/members', notice: "Member '#{mem_name}' has been deleted.")
    end
  end

  private

  # todo: use rubygem 'fuzzy-string-match' to generates alternatives candidates
  def notice_message(user_name)
    "User name '#{user_name}' not found"
  end

  def cookie_val
    if cookies['member_reserves'] == 'true'
      'active_and_reserves'
    else
      'active_only'
    end
  end

end
