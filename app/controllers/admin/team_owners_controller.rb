class Admin::TeamOwnersController < ApplicationController
  skip_around_action :scope_current_team
  before_action      :authenticate_member!

  def index
    @team = current_team
    @members = @team.members.reserve.by_last_name
  end

  def update
    id = params[:id]
    mem = Membership.find(id)
    mem.update_attribute(:owner_plus, params[:owner_plus])
    mem.update_rights_and_scores!
    render plain: 'OK', layout: false
  end
end
