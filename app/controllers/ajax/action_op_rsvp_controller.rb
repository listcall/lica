class Ajax::ActionOpRsvpController < ApplicationController

  before_action :authenticate_member!
  layout false

  def show
    incl       = [{:recipient => :user}, {:broadcast => :action}]
    @asid      = params[:asid]
    @dialog    = Pgr::Dialog::AsPaging.includes(incl).find(params[:id])
    @recipient = @dialog.recipient
    @action    = @dialog.broadcast.action
    @current   = @action.current_response @dialog.action_response
  end

  # /ajax/action_op_rsvp/#{dialogId}?new_resp=Y&asid=22
  def update
    asid   = params[:asid]
    incl   = [{:recipient => :user}, {:broadcast => :action}]
    dialog = Pgr::Dialog::AsPaging.includes(incl).find(params[:id])
    dialog.add_action_post("answer was set to #{params[:new_resp]}")
    dialog.set_action_response(params[:new_resp])
    msg = {:success => 'answer was changed'}
    redirect_to "/paging/#{asid}", msg
  end
end
