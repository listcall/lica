# new_pgr

require_relative './base'

class Pgr::Send::Sms::NumberPool::Plivo < Pgr::Send::Sms::NumberPool::Base
  def self.nums
    Rails.env.development? ? PLIVO_SMS_NUMBERS_DEV : PLIVO_SMS_NUMBERS_PRO
  end
end