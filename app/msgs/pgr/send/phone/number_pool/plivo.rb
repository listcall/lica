# new_pgr

require_relative './base'

class Pgr::Send::Phone::NumberPool::Plivo < Pgr::Send::Phone::NumberPool::Base
  def self.nums
    Rails.env.development? ? PLIVO_SMS_NUMBERS_DEV : PLIVO_SMS_NUMBERS_PRO
  end
end