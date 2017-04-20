# new_pager

class Inbound::Sms::SmsOpenerController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    build_inbound
    save_inbound
    render :plain => 'OK', :status => 200
  end

  private

  def inbound_scope
    current_team.inbounds.becomes(Inbound::StiSms)
  end

  def build_inbound
    @inbound ||= inbound_scope.build
    @inbound.attributes = inbound_params
  end

  def save_inbound
    @inbound.save
    # TODO - run this in background
    Inbound::Base.new(@inbound).handle
  end

  def inbound_params
    inputs = params[:inbound]
    if inputs
      permitted = [:type, :proxy, :text, :fm, :to => []]
      inputs[:to]      = [inputs[:to]]
      inputs[:proxy]   = 'sms_opener'
      inputs[:type]    = 'Inbound::StiSms'
      inputs.permit(permitted)
    else
      {}
    end
  end
end
