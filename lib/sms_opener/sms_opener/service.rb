module SmsOpener
  class Service

    def initialize(settings)
      @settings = settings
    end

    def deliver
      msg_text = message.render_msg
      location = tmp_file_location(msg_text)
      save_tmp_file(msg_text, location)
      launch(location)
      'OK'
    end

    private

    def tmp_file_location(msg_text)
      tmp_fn = "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(msg_text)[0..6]}"
      "/tmp/#{tmp_fn}"
    end

    def launch(location)
      Launchy.open("file:///#{location}")
    end

    def save_tmp_file(msg_text, location)
      File.open(location, 'w') {|f| f.puts msg_text}
    end

    def message
      @msg ||= Message.new(settings)
    end

    attr_accessor :settings

  end
end
