class Inbound::Handler::PgrEmailNew

  attr_reader :inbound

  def initialize(inbound = nil)
    @inbound = inbound
  end

  def handle
    broadcast = Pgr::Broadcast::AsPagingCreate.create(new_params(inbound))
    Pgr::Util::GenBroadcast.new(broadcast).generate_all.deliver_all
  end

  private

  def new_params(inbound)
    {
      'sender_id'              => inbound.new_sender_id,
      'short_body'             => inbound.text,
      'long_body'              => '',
      'email'                  => true,
      'phone'                  => true,
      'recipient_ids'          => inbound.new_recipient_ids,
      'assignments_attributes' => inbound.new_assignments_attributes,
    }
  end
end