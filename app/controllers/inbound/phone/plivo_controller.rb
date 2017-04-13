# new_pager

class Inbound::Phone::PlivoController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    build_inbound
    green_log 'PLIVO INBOUND IS BUILT'
    save_inbound
    green_log "PLIVO INBOUND IS SAVED (ID: #{@inbound.id})"
    render plain: 'OK'
  end

  private

  def inbound_scope
    from = params['From']
    to   = params['To']
    opts = {origin_address: to, target_address: from}
    dev_log 'building inbound scope'
    dev_log opts.to_s
    last_outbound = Pgr::Outbound::StiPhone.where(opts).recent.first
    dialog = last_outbound.dialog
    dialog.inbounds.becomes(Inbound::StiPhone)
  end

  def build_inbound
    @inbound ||= inbound_scope.build
    @inbound.attributes = inbound_params
  end

  def save_inbound
    @inbound.save
    # TODO - run this in background(?)
    Inbound::Base.new(@inbound).handle
  end

  def inbound_params
    # permitted = [:type, :proxy, :text, :fm, :to => []]
    inputs = {}
    if params
      inputs[:to]      = [params['To']]
      inputs[:fm]      = params['From']
      inputs[:text]    = params['Text']
      inputs[:proxy]   = 'plivo'
      inputs[:type]    = 'Inbound::StiPhone'
      inputs
    else
      {}
    end
  end

  # {
  #   "From"=>"16508230836",
  #   "TotalRate"=>"0.00000"
  #   "Text"=>"Eritt",
  #   "To"=>"14159153695",
  #   "Units"=>"1",
  #   "TotalAmount"=>"0.00000",
  #   "Type"=>"sms",
  #   "MessageUUID"=>"2ad5e8ac-97a1-11e4-9bd8-22000afa12b9",
  #   "controller"=>"inbound/phone/plivo",
  #   "action"=>"create"
  # }

end
