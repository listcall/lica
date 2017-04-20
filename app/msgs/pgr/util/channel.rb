class Pgr::Util::Channel
  def self.device_for(target)
    case target
      when "sms"   then "phone"
      when "email" then "email"
      else raise("Unrecognized channel (#{target})")
    end
  end
end