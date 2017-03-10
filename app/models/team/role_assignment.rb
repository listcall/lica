require 'app_ext/pkg'

class Team::RoleAssignment < ActiveRecord::Base

  # ----- Attributes -----

  # ----- Associations -----

  belongs_to :role, class_name: 'Team::Role', foreign_key: 'team_role_id'
  belongs_to :membership

  # ----- Validations -----

  # ----- Callbacks -----
  before_create :set_start_time

  # ----- Scopes -----
  scope :latest, -> { order('created_at DESC') }

  # ----- Class Methods -----
  class << self
    def create_for(mem, acronym)
      return unless mem.id.present?
      team_role = mem.team.roles.find_by(acronym: acronym)
      create(membership_id: mem.id, team_role_id: team_role.id)
    end

    def retire_for(mem, acronym)
      return unless mem.try(:id)
      team_role = mem.team.roles.find_by(acronym: acronym)
      opts      = {membership_id: mem.id, team_role_id: team_role.id}
      assig     = where(opts).latest.first
      return if assig.blank?
      assig.update_attributes(finished_at: Time.now)
      assig.reload
      assig.destroy if assig.elapsed_time < 10.minutes
    end
  end

  # ----- Instance Methods -----

  def elapsed_time
    self.finished_at - self.started_at
  end

  private

  def set_start_time
    self.started_at = Time.now
  end

end

# == Schema Information
#
# Table name: team_role_assignments
#
#  id            :integer          not null, primary key
#  team_role_id  :integer
#  membership_id :integer
#  started_at    :datetime
#  finished_at   :datetime
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
