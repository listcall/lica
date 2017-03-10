# TODO: segregate public/private methods

require 'pgr/send/phone/number_pool/plivo'

class Pgr::Outbound::StiPhone < Pgr::Outbound

  # ----- class methods -----
  def self.sms_match(mem_num: 'TBD', svc_num: 'TBD')
    qry = {target_address: mem_num, origin_address: svc_num}
    where(qry).recent
  end

  def self.by_target_address(num)
    where(target_address: num).recent
  end

  def self.with_valid_origin
    where("origin_address ~ '[0-9]'")
  end

  # ----- instance methods -----
  def deliver
    return if sent?
    Pgr::Send::Phone::Base.env_sender(self).deliver
  end

  def get_origin_number
    num = first_post_in_dialog? ? next_in_number_pool : first_origin_number_in_dialog
    dev_log 'Origin Number Pool (array)', origin_number_pool.numlist
    dev_log "Last Origin Number: #{last_origin_number}"
    dev_log "NEW NUMBER: #{num}"
    num
  end

  def action_footer
    return '' unless post.dialog.broadcast.action.present?
    post.dialog.broadcast.action.phone_helper.footer(self)
  end

  def text
    "[#{team.acronym}] " +
    post.short_body + " (from #{author.last_name}) #{action_footer}"
  end

  def fqdn
    post.dialog.broadcast.team.fqdn_with_port
  end

  private

  def origin_number_pool
    Pgr::Send::Phone::NumberPool::Plivo
  end

  def first_post_in_dialog?
    dialog.posts.count == 1
  end

  def last_origin_number
    select = self.class.by_target_address(target_address)
    select.with_valid_origin.first.try(:origin_address)
  end

  def next_in_number_pool
    origin_number_pool.next(last_origin_number)
  end

  def first_origin_number_in_dialog
    result = self.dialog_peers.phone.recent.first.try(:origin_address)
    result == "NA" ? next_in_number_pool : result
  end
end

# == Schema Information
#
# Table name: pgr_outbounds
#
#  id             :integer          not null, primary key
#  type           :string
#  pgr_post_id    :integer
#  target_id      :integer
#  device_id      :integer
#  device_type    :string
#  target_channel :string
#  origin_address :string
#  target_address :string
#  bounced        :boolean          default("false")
#  xfields        :hstore           default("")
#  sent_at        :datetime
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
