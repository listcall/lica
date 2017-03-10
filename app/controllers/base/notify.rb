class ActionController::Base

  def local_cast(channel, string)
    message = {:channel => channel, :data => string}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def as_notify(label, hash)
    ActiveSupport::Notifications.instrument(label, hash)
  end

end