require 'app_ext/pkg'

class Team::RankAssignment < ActiveRecord::Base

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :rank, class_name: 'Team::Rank', foreign_key: 'team_rank_id'
  belongs_to :membership

  # ----- Scopes -----
  scope :current   , -> { where(finished_at: nil)   }
  scope :latest    , -> { order('created_at DESC')  }

  # ----- Validations -----

  # ----- Callbacks -----
  before_save :set_start_time

  # ----- Class Methods -----
  class << self
    def create_for(mem)
      return unless mem.id.present?
      acronym   = mem.rank
      team_rank = mem.team.ranks.find_by(acronym: acronym)
      create(membership_id: mem.id, team_rank_id: team_rank.id)
    end
  end

  # ----- Instance Methods -----
  def set_start_time
    self.started_at ||= Time.now
  end

  def set_finish_time
    set.finished_at = Time.now
  end

  def elapsed_time
    Time.now - started_at
  end
end

# == Schema Information
#
# Table name: team_rank_assignments
#
#  id            :integer          not null, primary key
#  team_rank_id  :integer
#  membership_id :integer
#  started_at    :datetime
#  finished_at   :datetime
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
