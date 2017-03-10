# integration_test: features/dispay/role_log

class Display::RoleLogController < ApplicationController

  before_action :authenticate_manager!

  def index
    @roles = current_team.roles
  end

  def show
    @role = current_team.roles.find_by_acronym(params[:id])
  end
end
