require 'erb'

module SmsOpener
  class Message

    include Rails.application.routes.url_helpers

    def initialize(settings)
      @settings = settings
      @text     = settings.fetch(:text)
      @to       = settings.fetch(:to)
      @fm       = settings.fetch(:fm)
      @fqdn     = settings.fetch(:fqdn)
    end

    def render_msg
      ERB.new(sms_template).result(binding)
    end

    private

    def sms_template
      File.read(__dir__ + '/sms_message.html.erb')
    end

  end
end
