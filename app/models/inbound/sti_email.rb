# integration_test: requests/pgr/interaction requests/pgr/multi_partner

class Inbound::StiEmail < Inbound

  # ----- instance methods -----

  def reply_dialog_id
    @reply_dialog_id ||= begin
      val = self.headers['In-Reply-To']
      dev_log "EMAIL REPLY-TO: #{val}"
      if val.blank?
        err_log "Inbound (ID: #{self.id}) missing Reply-To"
        return nil
      end
      capture = val.match(/pgr-(\d+)-\d+@/)
      capture[1] if capture
    end
  end

  def reply_author_id
    @reply_author_id ||= begin
      user = User::Email.find_by(address: self.fm).user
      mbr_ids = Membership.where(user_id: user.id).pluck(:id)
      ptp_ids = Pgr::Dialog.find(reply_dialog_id).participant_ids
      (mbr_ids & ptp_ids).uniq.first
    end
  end

  def new_sender_id
    @new_sender_id ||= begin
      user = User::Email.find_by(address: self.fm).user
      Membership.find_by(team_id: self.team_id, user_id: user.id).try(:id)
    end
  end

  def new_recipient_ids
    @new_recipient_ids ||= begin
      self.to.map do |adr|
        address_name = adr.split('@').first
        hsh = Inbound::Util::Lookup.new(self.team).match_recipients(address_name)
        info_log hsh.to_s
        hsh.first.try(:[], :id)
      end
    end
  end

  def new_assignments_attributes
    @new_assignments_attributes ||= begin
      # TODO: get the pgr_ids for partner teams, not just the current team
      [{'pgr_id' => self.team.pgr.id}]
    end
  end

  # ----- validation checkers -----

  # is the origin email registered on the system?
  def orig_email_registered?
    return false if self.fm.nil?
    is_registered(self.fm)
  end

  # is the origin email from a member or a partner?
  def orig_email_allowed?
    is_allowed(self.fm)
  end

  def dest_email_valid?
    errors.clear
    to.each do |adr|
      (errors.add adr, '_unrecognized_address'; next) unless is_registered(adr)
      (errors.add adr, '_not_allowed_address' ; next) unless is_allowed(adr)
      errors.add adr, '_ambiguous_match' unless single_match(adr)
    end
    errors.count == 0
  end

  def team_domain
    team.fqdn
  end

  private

  # is the email address registered with the system
  def is_registered(email_adr)
    adr = email_adr.strip
    @recognized ||= Hash.new do |h, key|
      h[key] = User::Email.where('address ILIKE ?', adr).count == 1
    end
    @recognized[email_adr]
  end

  # is the email address associated with a member of the
  # current_team or a partner_team?
  def is_allowed(email_adr)
    adr = email_adr.strip
    @allowed ||= Hash.new do |h, key|
      user     = User::Email.where('address ILIKE ?', adr).to_a.first.user
      team_ids = [team_id] + team.partners.pluck(:id)
      h[key] = Membership.where(team_id: team_ids, user_id: user.id).count > 0
    end
    @allowed[email_adr]
  end

  def single_match(_email_adr)
    # handle ambiguous match
    # user Inbound::Svc::Lookup to see if there are multiple matches for the adr
    true
  end
end

# == Schema Information
#
# Table name: inbounds
#
#  id               :integer          not null, primary key
#  team_id          :integer
#  pgr_dialog_id    :integer
#  type             :string
#  proxy            :string
#  subject          :string
#  fm               :string
#  to               :string           default([]), is an Array
#  headers          :hstore           default({})
#  text             :text
#  destination_type :string
#  destination_id   :integer
#  xfields          :hstore           default({})
#  created_at       :datetime
#  updated_at       :datetime
#
