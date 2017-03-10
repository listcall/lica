class MemberCertsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @member = current_team.memberships.by_id_or_user_name(params[:id]).first.becomes(Membership::AsQuals)
    @quals = @member.post_quals
  end

  # todo: handle use-case for non-matching userid...
  # todo: use rubygem 'fuzzy-string-match' to generates alternatives candidates
  def show
    @qual_ctypes = current_team.qual_ctypes.to_a.map {|x| x.id}
    @member = current_team.memberships.by_id_or_user_name(params[:id]).first
  end

  def create
    memb  = Membership.find params['mcert']['membership_id']
    ucert = UserCert.create ucert_params
    mcert = MembershipCert.create mcert_params.merge({user_cert_id: ucert.id})
    redirect_to "/members/#{params["id"]}/certs"
  end

  def destroy
    mc   = MembershipCert.find(params['cert_id'])
    ucid = mc.user_cert_id
    mc.destroy
    uc   = UserCert.find(ucid)
    uc.destroy if uc.membership_certs.count.zero?
    redirect_to "/members/#{params[:id]}/certs"
  end

  def update
    uc = MembershipCert.find(params['cert_id']).user_cert
    uc.update_attributes(ucert_params)
    redirect_to "/members/#{params[:id]}/certs"
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
