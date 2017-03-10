class Ajax::BannedEmailsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def index
    respond_with ForumBannedEmail.where(team_id: current_team.id).to_a
  end

  def show
    respond_with ForumBannedEmail.find(params[:id])
  end

  def create
    opts = {
        team_id: current_team.id,
        address: params['banned_email']['address']
    }
    bane = ForumBannedEmail.create(opts)
    respond_with :api, bane
  end

  def update
    respond_with ForumBannedEmail.update(params[:id], valid_params(params[:banned_email]))
  end

  def destroy
    respond_with ForumBannedEmail.destroy(params[:id])
  end

  private

  def valid_params(params)
    params.permit(:address)
  end

end
