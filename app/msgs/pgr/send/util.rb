#required_by: msgs/pgr/send/email/base
#required_by: msgs/pgr/send/phone/base

module Pgr::Send::Util

  def env_sender(outbound)
    sender(outbound)
  end

  private

  def proxy_class(outbound, env = Rails.env.to_s)
    env = 'dev_live' if dev_live_test(env, outbound)
    proxies[env]
  end

  def dev_live_test(env, outbound)
    return false if env == :double
    env == 'development' && live_from_dev?(outbound)
  end

  def sender(outbound)
    klas = proxy_class(outbound)
    dev_log "DELIVERY KLAS: #{klas} / #{outbound.id} "
    klas.new(outbound)
  end

  # ----- placeholders -----

  def proxies
    raise 'Implement in SuperClass!'
  end

  def live_from_dev?(_outbound)
    raise 'Implement In SuperClass!'
  end
end