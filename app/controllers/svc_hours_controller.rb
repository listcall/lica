class SvcsHoursController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @services = current_team.svcs
    @ser_pars = service_partner_setup
    @reports  = Rep::StiService.where(team: current_team)
  end

  def show
    @services       = current_team.svcs
    @member         = current_team.memberships.by_user_name(params[:id]).first
    @participations = @member.svc_participations
  end
end
