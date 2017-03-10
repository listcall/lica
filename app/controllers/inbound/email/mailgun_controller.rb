class Inbound::Email::MailgunController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    dump_params
    build_inbound
    green_log 'MAILGUN INBOUND IS BUILT'
    save_inbound
    green_log "MAILGUN INBOUND IS SAVED (ID: #{@inbound.id})"
    head(:ok)
  end

  private

  def dump_params
    File.open('/tmp/mailgun.class', 'w') { |f| f.puts params.class   }
    File.open('/tmp/mailgun.yaml', 'w')  { |f| f.puts params.to_yaml }
  end

  def payload
    @payload ||= params['elements']
  end

  def inbound_scope
    current_team.inbounds.becomes(Inbound::StiEmail)
  end

  def build_inbound
    @inbound ||= inbound_scope.build
    @inbound.attributes = inbound_params
  end

  def save_inbound
    @inbound.save
    dev_log "INBOUND", @inbound.attributes, color: 'purple'
    # TODO: run this in background
    Inbound::Base.new(@inbound).handle
  end

  def inbound_params
    dev_log 'Mailgun Inbound'
    capture = {}
    if params
      capture[:fm]      = params['sender']
      capture[:to]      = recipient_array
      capture[:subject] = params['subject']
      capture[:headers] = header_hash
      capture[:proxy]   = 'mailgun'
      capture[:type]    = 'Inbound::StiEmail'
      capture[:text]    = params['body-plain']
      dev_log "CAPTURE", capture.to_yaml
      capture
    else
      dev_log "NO PARAMS", color: 'red'
      {}
    end
  end

  # ----- helper methods -----

  def recipient_array
    params['recipient'].split(',').map(&:strip)
  end

  def header_hash
    hda = [
      ['In-Reply-To', params['In-Reply-To']],
      ['Message-ID',  params['Message-Id']]
    ].select {|x| x.last.present?}
    hda.reduce({}) { |acc, val| acc[val.first] = val.last; acc }
  end
end

