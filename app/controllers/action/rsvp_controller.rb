class Action::RsvpController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    dev_log params.to_unsafe_h
    @params      = params.to_unsafe_h
    @response    = params.to_unsafe_h["response"]
    @outbound_id = params.to_unsafe_h["outbound_id"]
    @outbound    = Pgr::Outbound::StiEmail.find(@outbound_id)
    @dialog      = @outbound.dialog
    @action      = @dialog.action
    @dialog.add_action_post("answer was set to #{@response}")
    @dialog.set_action_response(@response)
  end
end

