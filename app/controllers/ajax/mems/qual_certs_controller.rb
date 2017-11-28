class Ajax::Mems::QualCertsController < ApplicationController

  before_action :authenticate_member!

  respond_to :json, :html
  layout false

  def show
    @member   = current_team.memberships.by_id_or_user_name(params[:membership_id]).first
    @ctype    = QualCtype.find(params['id'])
    @qual     = Qual.find(params['qid'])
    @certs    = MembershipCert.where(membership_id: @member.id, qual_ctype_id: @ctype.id).order(:position)
    @cert     = @certs.first
  end
end
