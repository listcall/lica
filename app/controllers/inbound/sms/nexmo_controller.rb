# new_pager

class Inbound::Sms::NexmoController < ApplicationController

  # skip_before_action :verify_authenticity_token
  #
  # def create
  #   begin
  #     devlog "NEXMO CONTROLLER", params
  #     SmsInboundSvc.new(params).handle
  #   rescue
  #     devlog "THERE WAS AN ERROR"
  #   end
  #   render plain: 'OK', layout: false
  # end

end
