class SvcsController < ApplicationController

  include SvcUtil
  before_action :authenticate_reserve!

  def index
    @editable = manager_rights?
    current_team.svcs.create(name: "Default", acronym: "def") if current_team.svcs.blank?
    @services = current_team.svcs
    @ser_pars = service_partner_setup
    @svc_bot  = ServiceBot.new(current_team)
    @reports  = Rep::StiService.where(team: current_team)
  end

  def show
    @services = current_team.svcs
    @service  = Svc.find params[:service_id]
    @ser_pars = service_partner_setup
    @member   = current_team.memberships.by_user_name(params[:id]).to_a.first
  end

  def update
    dev_log 'IN UPDATE'
  end

  def destroy
    dev_log 'IN DESTROY'
  end
end
