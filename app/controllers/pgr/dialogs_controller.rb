# integration_test: features/pgr/reply
# integration_test: requests/pgr/followup

require 'ext/ar_proxy'

class Pgr::DialogsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @assig   = load_assignment#.becomes(Pgr::Assignment::AsPagingFollowup)
    dev_log @assig.class
    @dialogs = load_dialogs
    @action_type             = @assig.broadcast.action.try(:label) || "NONE"
    dev_log "BING"
    @all_recipients          = @assig.broadcast.all_recips.map {|x| [x.id, "#{x.last_name}"]}.to_json
    @unresponsive_recipients = @assig.broadcast.unres_recips.map {|x| [x.id, "#{x.last_name}"]}.to_json
  end

  # send followup
  def create
    @sid   = params[:a_sid]
    @assig = current_team.pager_assignments.find_by_sequential_id(@sid)
    dev_log params.to_unsafe_h, @sid
    dev_log @assig.class
    followup    = FollowupVal.new(params.to_unsafe_h["fup"])
    obj = Pgr::Util::GenFollowup.new(@assig, followup).generate_all.deliver_all
    redirect_to "/paging/#{@sid}"
  end

  private

  # ----- assignment -----

  def load_assignment
    @assig_container ||= dialog_conf.assignment_for(params.to_unsafe_h[:b_id])
  end

  # ----- dialog -----

  def load_dialogs
    @dialogs_container ||= dialog_conf.dialogs_for(load_assignment)
  end

  # ----- misc -----

  def dialog_conf
    @conf_container ||= VwDialogs.new(current_team)
  end
end
