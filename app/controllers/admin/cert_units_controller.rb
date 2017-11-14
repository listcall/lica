class Admin::CertUnitsController < ApplicationController

  before_action :authenticate_owner!

  def index
    @units = current_team.cert_units
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
