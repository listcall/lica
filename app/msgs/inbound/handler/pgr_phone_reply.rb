# new_pgr

class Inbound::Handler::PgrPhoneReply

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    dev_log "Inbound Phone Klas: #{self.class.name}"
    dialog_id = inbound.reply_dialog_id
    if dialog_id.blank?
      err_log "ERROR: Invalid Inbound ID #{self.headers}"
      err_log "Skipping Inbound (ID: #{@inbound.id})"
      return
    end
    dialog = Pgr::Dialog.find(dialog_id)
    params = post_params(inbound)
    Pgr::Util::GenReply.new(dialog, params).deliver_all
  end

  private

  def post_params(inbound)
    {
      pgr_dialog_id:    inbound.reply_dialog_id,
      author_id:        inbound.reply_author_id,
      short_body:       inbound.text,
      long_body:        '',
      target_channels:  %i(phone),
      author_channel:   "phone",
      author_address:   inbound.fm.phone_dasherize
    }
  end
end