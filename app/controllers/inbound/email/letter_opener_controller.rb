# integration_test: requests/pgr/interaction

class Inbound::Email::LetterOpenerController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    dev_log params, color: 'blue'
    build_inbound
    dev_log 'OPENER INBOUND IS BUILT',  color: 'green'
    dev_log params[:inbound][:to].to_s, color: 'green'
    save_inbound
    dev_log 'OPENER INBOUND IS SAVED',  color: 'green'
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
    # TODO: run this in a background worker
    Inbound::Base.new(@inbound).handle
  end

  def inbound_params
    inputs = params[:inbound]
    dev_log "STARTING INBOUND PARAMS #{inputs[:to]}", color: 'green'
    if inputs
      inputs[:fm]      = inputs[:from]
      inputs[:to]      = to_array
      inputs[:headers] = header_hash
      inputs[:proxy]   = 'letter_opener'
      inputs[:type]    = 'Inbound::StiEmail'
      inputs.permit(permitted)
    else
      {}
    end
  end

  # ----- helper methods -----

  def permitted
    base = %i(type proxy fm subject text)
    to   = [{to: []}]
    hdrs = [{headers: %w(Message-ID In-Reply-To)}]
    base + to + hdrs
  end

  def to_array
    val = params[:inbound][:to]
    dev_log "IN TOARRAY (#{val})"
    return val if val.is_a?(Array)
    val.split(',').map(&:strip)
  end

  def header_hash
    hda = %w(In-Reply-To Message-ID).map { |x| [x, params[x]] }
    hda.reduce({}) { |acc, val| acc[val.first] = val.last; acc }
  end
end
