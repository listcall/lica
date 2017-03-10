# inspired by 'mandrill_dm' gem

require 'mandrill'

module DeliveryMethod
  class MandrillDm
    attr_accessor :settings

    def initialize(options = {})
      self.settings = options
    end

    def deliver!(mail)
      mandrill = Mandrill::API.new(MANDRILL_API_KEY)
      message  = MandrillMessage.new(mail).to_json
      dev_log 'STARTING MANDRILL SENDER'
      result   = mandrill.messages.send(message)
      dev_log 'SENT MANDRILL MESSAGE'
      data_log result, color: 'purple'
      # if result["reject_reason"].present?
      #   err_log "Error in Sending"
      #   data_log result.to_s, color: "red"
      # else
      #   data_log result.to_s
      # end
      # raise "MANDRILL SEND ERROR" if result["reject_reason"].present?
      # TODO: only update outbound if result code is successful
      oid = mail.header['Outbound-ID'].try(:value)
      Pgr::Outbound.find(oid).try(:touch, :sent_at) if oid
    end
  end

  class MandrillMessage
    attr_reader :mail

    def initialize(mail)
      @mail      = mail
      @team_name = @mail.from.first.split('@').last.split('.').first
    end

    def html
      @mail.html_part ? @mail.html_part.body.decoded : @mail.body.decoded
    end

    def text
      @mail.multipart? ? (@mail.text_part ? @mail.text_part.body.decoded : nil) : nil
    end

    def subject
      @mail.subject
    end

    def from_email
      from.address
    end

    def from_name
      from.display_name
    end

    def to
      combine_address_fields.reject{|h| h.nil?}.flatten
    end

    def headers
      {'Message-ID' => "<#{@mail.message_id}>"}
    end

    def bcc_address
      @mail.header['bcc_address'].to_s
    end

    def message_id
      @message_id ||= Array(@mail['message-id']).join(', ')
    end

    def subaccount
      @mail.header['subaccount'].to_s
    end

    def to_json
      {
        html:       html,
        text:       text,
        subject:    subject,
        from_email: from_email,
        from_name:  from_name,
        to:         to,
        headers:    headers
      }
    end

    private

    # Returns a single, flattened hash with all to, cc, and bcc addresses
    def combine_address_fields
      %w[to cc bcc].map do |field|
        hash_addresses(@mail[field])
      end
    end

    # Returns a Mail::Address object using the from field
    def from
      address = @mail[:from].formatted
      Mail::Address.new(address.first)
    end

    # Returns a Mandrill API compatible email address hash
    def hash_addresses(address_field)
      return nil unless address_field

      address_field.formatted.map do |address|
        address_obj = Mail::Address.new(address)
        {
          email: address_obj.address,
          name: address_obj.display_name,
          type: address_field.name.downcase
        }
      end
    end
  end
end