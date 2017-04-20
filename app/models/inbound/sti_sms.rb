class Inbound::StiSms < Inbound

  # ----- instance methods -----

  # is the origin phone registered on the system?
  def orig_phone_registered?
    return false if self.fm.nil?
    User::Phone.where(number: self.fm.phone_dasherize).count == 1
  end

  # is the origin phone from a member or a partner?
  def orig_phone_allowed?
    # user = User::Phone.where(number: self.fm.phone_dasherize).to_a.first.user
    # team_ids = [team_id] + team.partners.pluck(:id)
    # Membership.where(team_id: team_ids, user_id: user.id).count > 0
    true
  end

  def reply_dialog
    @reply_dialog ||= begin
      opts = {origin_address: self.to, target_address: self.fm}
      last_outbound = Pgr::Outbound::StiSms.where(opts).recent.first
      last_outbound.dialog
    end
  end

  def reply_dialog_id
    reply_dialog.id
  end

  def reply_author_id
    @reply_author_id ||= begin
      user = User::Phone.find_by(number: self.fm.phone_dasherize).user
      memb = reply_dialog.participants.find {|mem| mem.user_id == user.id}
      memb.try(:id)
    end
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
#  to               :string           default("{}"), is an Array
#  headers          :hstore           default("")
#  text             :text
#  destination_type :string
#  destination_id   :integer
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
