class Pgr::Action::StiOpRsvpHelpers::Phone

  attr_reader :parent

  def initialize(parent)
    @parent = parent
    self
  end

  def footer(_outbound)
    "RSVP: #{parent.query_msg}"
  end
end