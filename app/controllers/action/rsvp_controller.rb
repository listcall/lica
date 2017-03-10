class Action::RsvpController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    dev_log params
    @params      = params
    @response    = params["response"]
    @outbound_id = params["outbound_id"]
    @outbound    = Pgr::Outbound::StiEmail.find(@outbound_id)
    dialog       = @outbound.dialog
    dialog.add_action_post("answer was set to #{@response}")
    dialog.set_action_response(@response)
  end
end

