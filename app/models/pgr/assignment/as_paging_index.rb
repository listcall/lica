class Pgr::Assignment::AsPagingIndex < ActiveType::Record[Pgr::Assignment]

  include ActiveType::Helpers

  change_association :broadcast, class_name: 'Pgr::Broadcast::AsPagingShow'

  methods = %i(action short_body long_body created_at read_count recipient_ids comment_icon_for action_status is_clear? is_red?)

  delegate *methods, :to => :broadcast

  class << self
    def for(team)
      opts = {:broadcast => [{:action => :broadcast}, {:sender => [:user, {:team => :org}]}]}
      team.pgr.assignments.becomes(self).includes(opts).order(:id => :desc)
    end
  end

  def sender
    broadcast.try(:sender)
  end

  def sender_user
    sender.try(:user)
  end

  def sender_name(default = "TBD")
    sender_user.try(:user_name) || default
  end

  def sender_id
    sender_user.try(:id)
  end

  def sender_path
    "/members/#{sender_id}"
  end

  def recipient_count
    recipient_ids.try(:length)
  end

  def broadcast_path
    "/paging/#{sequential_id}"
  end

  def reply_count_link
    broadcast.post_count_link(sequential_id, "reply")
  end

  # ----- for broadcasts -----

  def recip_count
    recipient_ids.length
  end

  def recip_people
    h.pluralize(recip_count, 'recipient')
  end

  def via
    return '' unless broadcast.sms || broadcast.email
    chan = [broadcast.email ? 'eMail' : nil, broadcast.sms ? 'SMS' : nil].select {|x| x.present?}.join(', ')
    " via #{chan}"
  end

  def message_text
    "#{short_body} #{long_body}"
  end

  def action_header
    return '' if action.blank?
    "<b>#{action.label}: #{action.query_msg.capitalize}?</b> #{action.header} <small>#{action.status_msg_long}</small><p></p>"
  end

  # ----- for followups -----

  def recip_names
    broadcast.all_recips.map do |x|
      x.last_name
    end.sort.join(", ")
  end

  def recip_ids
    broadcast.all_recips.map do |x|
      x.id
    end.sort.join(",")
  end
end

# == Schema Information
#
# Table name: pgr_assignments
#
#  id               :integer          not null, primary key
#  sequential_id    :integer
#  pgr_id           :integer
#  pgr_broadcast_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#
