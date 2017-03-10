require 'mailgun'

module DeliveryMethod
  class MailgunDm
    attr_accessor :settings

    def initialize(options = {})
      self.settings = options
    end

    def deliver!(mail)
      msg = MailgunMessage.new(mail)
      dev_log 'STARTING MAILGUN SENDER'
      result = send_message(msg)
      dev_log 'SENT MAILGUN MESSAGE'
      data_log result
    end

    private

    def send_message(msg)
      url = "https://api:#{MAILGUN_API_KEY}@api.mailgun.net/v3/#{msg.team_domain}/messages"
      dev_log "URL", url
      dev_log "DATA", msg.data
      data = RestClient.post url, msg.data
      dev_log "DONE SENDING", data
      data
    end
  end

  class MailgunMessage
    attr_reader :mail

    def initialize(mail)
      @mail = mail
    end

    def team_domain
      @mail.from.first.split('@').last
    end

    def team_name
      team_domain.split('.').first
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
      combine_recipient_addresses
    end

    def headers
      {'Message-ID' => message_id}
    end

    def message_id
      "<#{@mail.message_id}>"
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



    def data
      {
        "html"         =>    html,
        "text"         =>    text,
        "subject"      =>    subject,
        "from"         =>    from_email,
        "to"           =>    to,
        "h:Message-ID" =>    message_id
      }
    end

    private

    # Returns a single, flattened hash with all to, cc, and bcc addresses
    def combine_recipient_addresses
      %w[to cc bcc].map do |field|
        hash_addresses(@mail[field])
      end.reject {|h| h.nil?}.join(',')
    end

    # Returns a Mail::Address object using the from field
    def from
      address = @mail[:from].formatted
      Mail::Address.new(address.first)
    end

    # Returns a Mailgun API compatible email address hash
    def hash_addresses(address_field)
      return nil unless address_field

      address_field.formatted.map do |address|
        address_obj = Mail::Address.new(address)
        # {
        #   email: address_obj.address,
        #   name: address_obj.display_name,
        #   type: address_field.name.downcase
        # }
        name = address_obj.display_name.blank? ? "" : "#{address_obj.display_name} "
        "#{name}<#{address_obj.address}>"
      end
    end
  end
end