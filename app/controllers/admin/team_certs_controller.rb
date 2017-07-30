class Admin::TeamCertsController < ApplicationController

  before_action :authenticate_owner!

  def index
    # @partner_bot = PartnerBot.new(current_team)
    @certs = current_team.cert_specs
  end

  def create
    TeamPartnership.request(current_team, Team.find(params[:partner_id]))
    render plain: 'OK'
  end

  def update
    TeamPartnership.accept(current_team.id, params[:id])
    render plain: 'OK'
  end

  def destroy
    TeamPartnership.reject(current_team.id, params[:id])
    redirect_to '/admin/team_partners'
  end

end
