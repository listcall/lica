class Admin::TeamOwnersController < ApplicationController
  skip_around_action :scope_current_team
  before_action      :authenticate_owner!

  def index
    @team = current_team
    @members = @team.members.reserve.by_last_name
  end

  def update
    id = params[:id]
    mem = Membership.find(id)
    mem.update_attribute(:owner_plus, params[:owner_plus])
    mem.update_rights_and_scores!
    render text: 'OK', layout: false
  end
end
