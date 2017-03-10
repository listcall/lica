class QualCertsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @quals  = current_team.quals.includes([:qual_ctypes, :team])
    @qual   = Qual.includes(:team).find(params[:id])
    @mems   = @qual.sorted_post_members
    @types  = @qual.qual_ctypes
  end

  def show
    @qual        = Qual.find(params[:id])
    @member      = Membership.find(params[:member_id])
    @editable    = current_membership == @member || manager_rights?
  end

  def destroy
    mc   = MembershipCert.find(params['mcert_id'])
    member = mc.membership
    ucid = mc.try(:user_cert).try(:id)
    mc.destroy
    unless ucid.nil?
      uc = UserCert.find(ucid)
      uc.destroy if uc.membership_certs.count.zero?
    end
    redirect_to "/quals/#{params[:id]}/certs/#{member.id}"
  end

  def sort
    params['certSort'].each_with_index do |cid,idx|
      MembershipCert.find(cid).update_attributes(position: idx+1)
    end
    render text: 'OK', layout: false
  end

  private

  def ucert_params
    params['ucert'].permit :user_id, :title, :comment, :expires_at, :attachment
  end

  def mcert_params
    params['mcert'].permit :membership_id, :qual_ctype_id
  end

end
