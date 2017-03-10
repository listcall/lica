class Admin::MemberDropController < ApplicationController

  before_action :authenticate_manager!

  def index
    # @form = RecruitForm.new(team_id: current_team.id)
    @query   = MemberRegistryQry.new(current_team, params)
    @members = @query.to_a
  end

  def destroy
    mem = Membership.find(params[:id])
    mem.destroy if mem.present?
    redirect_to '/admin/member_drop', :notice => "Member was dropped."
  end

  private

  def valid_params(params)
    params.permit *%i(team_id full_name rank form_rank phone_typ phone_num email_typ email_adr)
  end
end
