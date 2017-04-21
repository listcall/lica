class Pgr::Broadcast::AsPagingShow < ActiveType::Record[Pgr::Broadcast]

  include ActiveType::Helpers

  # ----- associations -----

  change_association :assignments, class_name: 'Pgr::Assignment::AsPagingShow'
  change_association :dialogs    , class_name: 'Pgr::Dialog::AsPaging'

  # ----- callbacks -----

  # ----- instance methods -----


  def posts_count
    dc = dialogs.count
    dialogs.joins(:posts).where('pgr_posts.type = ?', 'Pgr::Post::StiMsg').count - dc
  end

  def other_count
    return '' if recipient_ids.blank?
    count = recipient_ids.length - 1
    return '' if count == 0
    " (and #{h.pluralize(count, "other")})"
  end

  def post_count_link(assignment_sequential_id, label = 'reply')
    msg   = h.pluralize(posts_count, label)
    h.link_to msg, "/paging/#{assignment_sequential_id}"
  end

  # ----- for dialog -----

  def blah
    sms || email
  end

  def action_status
    return 'NA'   if action.blank?
    return 'TBD'  unless action.type == Pgr::Action::StiOpRsvp.to_s
    " #{action.label} <small>#{action.status_msg}</small>#{action.link_icons}"
  end
end

# == Schema Information
#
# Table name: pgr_broadcasts
#
#  id            :integer          not null, primary key
#  sender_id     :integer
#  short_body    :text
#  long_body     :text
#  deliver_at    :datetime
#  recipient_ids :integer          default("{}"), is an Array
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
