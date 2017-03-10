# integration_test: requests/pgr/multi_partner

class Pgr::Dialog::AsPaging < ActiveType::Record[Pgr::Dialog]

  include ActiveType::Helpers

  change_association :broadcast, class_name: 'Pgr::Broadcast::AsPagingShow'
  change_association :recipient, class_name: 'Membership::AsPaging'

  # ----- callbacks -----

  # ----- instance methods -----

  def action_status(assig)
    return 'NA' if broadcast.action.blank?
    answer = action_response.present? ? action_response : 'pending'
    "<a href='#' class='actLink inline_link' data-asid='#{assig.sequential_id}' data-pk='#{self.id}'>#{answer}</a>"
  end

  def action_full_status
    return 'NA' if broadcast.action.blank?
    answer = action_response.present? ? action_response : 'pending'
    answer
  end

  def recipient_read_label
    recipient_has_read? ? 'read' : 'not read'
  end

  def recipient_has_read?
    recipient_read_at.present?
  end

  def participant_ids
    [recipient_id, sender_id]
  end

  def is_participant?(current_member)
    current_id = current_member.to_i
    [recipient_id, sender_id].include? current_id
  end

  def other_participant_id(first)
    first_id = first.to_i
    raise "Unrecognized Participant #{first}" unless is_participant?(first_id)
    participant_ids.select {|id| id != first_id}.first || first_id
  end

  def posts_link(assig)
    count = posts.msgs.count - 1
    msg = h.pluralize(count, 'reply')
    h.link_to msg, "/paging/#{assig.sequential_id}/for/#{id}"
  end

  def updated_disp
    updated_at.strftime('%m-%d %H:%M')
  end

  def action_header
    action = broadcast.action
    return '' if action.blank?
    period = Event::Period.includes(:event => :team).find(action.period_id)
    event  = period.event
    lblock = <<-HTML.gsub("\n", '')
      [ #{event.typ_name}:
        <a href='/events/#{event.event_ref}' target='_blank'>
          #{event.title}
        </a>
        /
        <a href='/events/#{event.event_ref}/periods/#{period.position}' target='_blank'>
          OP#{period.position}
        </a>
      ]
    HTML
    line1 = "<br/><b>#{action.label}: #{action.query_msg.capitalize}?</b>"
    line2 = " #{lblock} <b>Answer:</b> #{action.current_response(action_response, separator: ' -')}"
    line1 + line2
  end


end

# == Schema Information
#
# Table name: pgr_dialogs
#
#  id                       :integer          not null, primary key
#  pgr_broadcast_id         :integer
#  recipient_id             :integer
#  recipient_read_at        :datetime
#  unauth_action_token      :string
#  unauth_action_expires_at :datetime
#  action_response          :string
#  xfields                  :hstore           default("")
#  jfields                  :jsonb            default("{}")
#  created_at               :datetime
#  updated_at               :datetime
#
