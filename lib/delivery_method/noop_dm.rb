module DeliveryMethod
  class NoopDm
    attr_accessor :settings

    def initialize(options = {})
      self.settings = options
    end

    def deliver!(mail)
      oid = mail.header['Outbound-ID'].try(:value)
      Pgr::Outbound.find(oid).try(:touch, :sent_at) if oid
    end
  end
end