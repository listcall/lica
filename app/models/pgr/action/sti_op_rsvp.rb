# integration_test: controllers/pgr/assignments_controller

require 'app_ext/pkg'
require_relative "./sti_op_rsvp_helpers/email_html"
require_relative "./sti_op_rsvp_helpers/email_text"
require_relative "./sti_op_rsvp_helpers/phone"

class Pgr::Action::StiOpRsvp < Pgr::Action

  # ----- attributes -----
  xfield_accessor :period_id

  # ----- associations -----
  # belongs_to :period, class_name: 'Event::Period'

  # ----- delegated methods -----
  def period
    begin
      @period ||= Event::Period.find(self.period_id.to_i)
    rescue
      @period ||= nil
    end
  end

  def event    ; period.try(:event)    ; end
  def event_id ; period.try(:event_id) ; end

  # ----- validation -----
  validates :period_id, presence: true

  # ----- class methods -----

  class << self
    def label
      'RSVP'
    end

    def about
      <<-EOF.gsub('      ','').gsub("\n", ' ')
        An RSVP allows the page recipient to reply with a
        YES/NO/MAYBE response.  RSVPs are associated with
        a single operational period.  When someone replies with
        a YES, they are automatically added to the roster for
        that operational period.
      EOF
    end

    def usage_ctxt
      'Requesting attendees for an event'
    end

    def has_period; true; end

    def action_for(text)
      reg = ->(tgts) { /(^|\s)(#{tgts.join('|')})(\s|$)/im }
      mtext = text[0..500].strip.split(' ').first || ""
      # case-insensitive match on first word in reply
      return 'yes'    if mtext.match(reg.call(targets[:yes])   )
      return 'no'     if mtext.match(reg.call(targets[:no])    )
      nil
    end

    def query_msg
      'Are you available?'
    end

    def prompts
      {
        'yes'   => 'available',
        'no'    => 'not available'
      }
    end

    private

    def targets
      {
        yes:   %i(yes y),
        no:    %i(no n)
      }
    end
  end

  # ----- instance methods (update roster) -----
  def change_state(member_id, response)
    is_yes = response.downcase == 'yes'
    is_yes ? add_to_roster(member_id) : remove_from_roster(member_id)
  end

  def add_to_roster(member_id)
    opts = {event_period_id: period_id, membership_id: member_id}
    Event::Participant.find_or_create_by(opts)
  end

  def remove_from_roster(member_id)
    opts = {event_period_id: period_id, membership_id: member_id}
    participant = Event::Participant.find_by(opts)
    participant.destroy if participant.present?
  end

  # ----- instance methods (prompts) -----
  def query_msg
    self.class.query_msg
  end

  def prompts
    self.class.prompts
  end

  def current_response(label, separator: ':')
    return 'Pending' unless prompts[label]
    "#{label.capitalize}#{separator} #{prompts[label]}"
  end

  # ----- instance methods (web page display)-----
  def label
    self.class.label
  end

  def status_msg
    "Y#{num_yes} N#{num_no} P#{num_pending}"
  end

  def status_msg_long
    "Yes: #{num_yes} No: #{num_no} Pending: #{num_pending}"
  end

  def link_icons
    period = Event::Period.find(period_id)
    <<-HTML.gsub("\n",'')
      <small style='margin-left: 5px;'>
      <a href='/events/#{event.try(:event_ref)}' target='_blank'>
        <i class='fa fa-calendar-o iconTip' title="#{event.try(:title)}"></i>
      </a>
      <a href='/events/#{event.try(:event_ref)}/periods/#{period.position}' target='_blank'>
        <i class='fa fa-adjust iconTip' title="OP#{period.position}"></i>
      </a>
      </small>
    HTML
  end

  def header
    period = Event::Period.includes(:event => :team).find(period_id)
    event  = period.event
    <<-HTML.gsub("\n", '')
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
  end

  # ----- instance methods (email) -----

  def reply(member_id: memid, response: resp)
    action = self.class.action_for(resp)
    send "on_#{action}", memid, resp
  end

  # ----- for assignments#index page -----

  def num_recipients
    broadcast.dialogs.count
  end

  def num_yes
    with_action_response('yes').count
  end

  def num_no
    with_action_response('no').count
  end

  def num_maybe
    with_action_response('maybe').count
  end

  def num_pending
    with_action_response(nil).count
  end

  def with_action_response(value)
    broadcast.dialogs.where(action_response: value)
  end

  # ----- message rendering helpers -----

  def email_html_helper
    @html_klas   ||= Pgr::Action::StiOpRsvpHelpers::EmailHtml
    @html_helper ||= @html_klas.new(self)
  end

  def email_text_helper
    @text_klas   ||= Pgr::Action::StiOpRsvpHelpers::EmailText
    @text_helper ||= @text_klas.new(self)
  end

  def phone_helper
    @sms_klas   ||= Pgr::Action::StiOpRsvpHelpers::Phone
    @sms_helper ||= @sms_klas.new(self)
  end

  # ----- for misc and sundry -----

  def current_response_msg(response)
    "#{response.upcase} : #{prompts[response]}"
  end

  def alt_response_msg(response)
    "#{opposite_response(response).upcase} : #{opposite_prompt(response)}"
  end

  def opposite_response(response)
    case response
      when "yes" then "no"
      when "no" then "yes"
    end
  end

  def opposite_prompt(response)
    prompts[opposite_response(response)]
  end

  def opposite_link(outbound, response)
    "/action/rsvp/#{outbound.id}/#{opposite_response(response)}"
  end

  # ----- for email rendering -----

  # TODO: FINISH THE ACTION HANDLERS
  # def on_yes(member_id)
  #   dev_log 'YES RESPONSE'
  #   period.add_participant(member_id)
  #   # add an info message to dialog
  #   # update status (read, status)
  # end
  #
  # def on_no(user, response)
  #   dev_log 'NO RESPONSE'
  #   # remove user from roster
  #   # add an info message to dialog
  #   # update status (read, status)
  # end
  #
  # def on_maybe(user, response)
  #   dev_log 'MAYBE RESPONSE'
  #   # add an info message to dialog
  #   # update status (read, status)
  # end
  #
  # def on_unrecognized(user, response)
  #   dev_log 'UNRECOGNIZED RESPONSE'
  #   # send autoreply to user (max one autoreply)
  #   # update status (read)
  # end
end

# == Schema Information
#
# Table name: pgr_actions
#
#  id               :integer          not null, primary key
#  pgr_broadcast_id :integer
#  type             :string
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
