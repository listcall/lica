class Inbound::Handler::PgrEmailReply

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    dialog_id = inbound.reply_dialog_id
    if dialog_id.blank?
      err_log "ERROR: Invalid Inbound ID #{self.headers}"
      err_log "Skipping Inbound (ID: #{@inbound.id})"
      return
    end
    begin
      dialog = Pgr::Dialog.find(dialog_id)
    rescue
      err_log "ERROR: dialog not found (ID: #{dialog_id})"
      return
    end
    params = post_params(inbound)
    Pgr::Util::GenReply.new(dialog, params).generate_all
  end

  private

  def post_params(inbound)
    {
      pgr_dialog_id:   inbound.reply_dialog_id,
      author_id:       inbound.reply_author_id,
      short_body:      inbound.text,
      long_body:       '',
      target_channels: %i(email),
      author_channel:  "email",
      author_address:  inbound.fm
    }
  end
end
