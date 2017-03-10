class ActionController::Base

  def device
    agent = env['HTTP_USER_AGENT']
    case agent
      when /Kindle/      then 'Kindle'
      when /Android/     then 'Android'
      when /iPod/        then 'iPod'
      when /iPhone/      then 'iPhone'
      when /iPad/        then 'iPad'
      when /BlackBerry/  then 'BlackBerry'
      when /chromeframe/ then 'Chromeframe'
      when /MSIE/        then 'IE'
      when /Silk/        then 'Silk'
      when /Firefox/     then 'Firefox'
      when /Konqueror/   then 'Konqueror'
      when /Netscape/    then 'Netscape'
      when /Opera/       then 'Opera'
      when /Chrome/      then 'Chrome'
      when /Safari/      then 'Safari'
      else  'Unknown'
    end
  end

  def ipad_device?
    device == 'iPad'
  end

  def phone_device?
    %w(Android iPhone BlackBerry).include? device
  end

  def touch_device?
    ipad_device? || phone_device?
  end

  helper_method :touch_device?

  def not_phone_device?
    ! phone_device?
  end

  helper_method :phone_device?
  helper_method :not_phone_device?

  def device_name
    devname  = device
    browsers = %w(Silk Firefox Konqueror Netscape Opera Chrome Safari Unknown)
    return 'phone'   if devname == 'Android'
    return 'browser' if browsers.include? devname
    devname
  end

end