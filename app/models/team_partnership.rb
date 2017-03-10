# inspired by http://francik.name/rails2010/week10.html

class TeamPartnership < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :team, touch: true
  belongs_to :partner, class_name: 'Team', foreign_key: 'partner_id'

  # ----- Callbacks -----

  # ----- Validations -----
  validates_presence_of :team_id, :partner_id

  # ----- Class Methods -----

  def self.are_partners(team, partner)
    return false if team == partner
    return true unless find_by_team_id_and_partner_id(team, partner).nil?
    return true unless find_by_team_id_and_partner_id(partner, team).nil?
    false
  end

  def self.request(team, partner)
    return false if are_partners(team, partner)
    return false if team == partner
    p1 = new(team: team,    partner: partner, status: 'pending')
    p2 = new(team: partner, partner: team,    status: 'requested')
    transaction do
      p1.save
      p2.save
    end
  end

  def self.accept(team, partner)
    f1 = find_by_team_id_and_partner_id(team, partner)
    f2 = find_by_team_id_and_partner_id(partner, team)
    if f1.nil? or f2.nil?
      return false
    else
      transaction do
        f1.update_attributes(:status => 'accepted')
        f2.update_attributes(:status => 'accepted')
      end
    end
    return true
  end

  def self.reject(team, partner)
    f1 = find_by_team_id_and_partner_id(team, partner)
    f2 = find_by_team_id_and_partner_id(partner, team)
    if f1.nil? or f2.nil?
      return false
    else
      transaction do
        f1.destroy
        f2.destroy
        return true
      end
    end
  end

  # ----- Scopes -----

  # ----- Local Methods-----

end

# == Schema Information
#
# Table name: team_partnerships
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  partner_id :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#
