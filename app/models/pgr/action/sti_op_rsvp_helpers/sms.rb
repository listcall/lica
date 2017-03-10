class Pgr::Action::StiOpRsvpHelpers::Sms

  attr_reader :parent

  def initialize(parent)
    @parent = parent
    self
  end

  def footer(_outbound)
    "FOOTER OUTBOUND #{__FILE__}"
  end

  private

  def tbd
    "UNDER CONSTRUCTION"
  end
end