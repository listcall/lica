# integration_test: features/dispay/cred_log

class Display::CredLogController < ApplicationController

  before_action :authenticate_manager!

  def index
    @mems = current_team.memberships.by_sort_score
  end

  def show
    @mem = current_team.memberships.by_id_or_user_name(params[:id]).first
  end
end
