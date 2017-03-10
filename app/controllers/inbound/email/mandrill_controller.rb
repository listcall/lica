class Inbound::Email::MandrillController < ApplicationController

  skip_before_action :verify_authenticity_token

  attr_reader :payload

  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(payload)
    @payload = payload
    build_inbound
    green_log 'MANDRILL INBOUND IS BUILT'
    save_inbound
    green_log "MANDRILL INBOUND IS SAVED (ID: #{@inbound.id})"
    render text: 'OK'
  end

  private

  def inbound_scope
    current_team.inbounds.becomes(Inbound::StiEmail)
  end

  def build_inbound
    @inbound ||= inbound_scope.build
    @inbound.attributes = inbound_params
  end

  def save_inbound
    @inbound.save
    # TODO: run this in background
    Inbound::Base.new(@inbound).handle
  end

  def inbound_params
    inputs = payload['msg']
    dev_log 'Mandrill Inbound'
    capture = {}
    if inputs
      capture[:fm]      = inputs['from_email']
      capture[:to]      = to_array
      capture[:subject] = inputs['subject']
      capture[:headers] = header_hash
      capture[:proxy]   = 'mandrill'
      capture[:type]    = 'Inbound::StiEmail'
      capture[:text]    = inputs['text']
      capture
    else
      {}
    end
  end

  # ----- helper methods -----

  def to_array
    payload['msg']['to'][0].select {|adr| adr.present?}
  end

  def header_hash
    hdr_base = payload['msg']['headers']
    hda = [
      ['In-Reply-To', hdr_base['In-Reply-To']],
      ['Message-ID',  hdr_base['Message-Id']]
    ].select {|x| x.last.present?}
    hda.reduce({}) { |acc, val| acc[val.first] = val.last; acc }
  end
end

