require 'app_ext/pkg'
require 'right'

class Team::Rank < ActiveRecord::Base

  acts_as_list :scope => :team_id, :column => :sort_key

  # ----- Attributes -----
  alias_attribute :label     , :acronym
  alias_attribute :position  , :sort_key

  # ----- Associations -----
  belongs_to :team
  has_many   :rank_assignments, class_name: 'Team::RankAssignment', foreign_key: 'team_rank_id'

  # ----- Validations -----
  VALID_RIGHTS = Right.options
  validates_presence_of  :rights
  validates_inclusion_of :rights, in: VALID_RIGHTS
  validates :name   , :presence => true, :uniqueness => {:scope => :team_id}
  validates :acronym, :presence => true, :uniqueness => {:scope => :team_id},
            :format   => {with: /\A[a-zA-Z\d]*\z/, message: 'only letters or numbers'}
  validate  :max_rank_count

  def max_rank_count
    return unless self.team.present?
    if self.class.where(team_id: team_id).count > 31
      errors.add(:role_id, 'Error - Max number of ranks reached')
    end
  end

  # ----- Callbacks -----
  after_initialize  :set_defaults
  before_validation :upcase_acronym

  # ----- Scopes -----
  scope :reserves, -> { where(rights: 'reserve') }

  # ----- Class Methods -----
  class << self
    def set_defaults_for(team)
      ids = [
        {acronym: 'INA', name: 'Inactive', rights: 'inactive' },
        {acronym: 'ALU', name: 'Alum',     rights: 'alum'     },
        {acronym: 'GST', name: 'Guest',    rights: 'guest'    },
        {acronym: 'RES', name: 'Reserve',  rights: 'reserve'  },
        {acronym: 'ACT', name: 'Active',   rights: 'active'   },
        {acronym: 'MGR', name: 'Manager',  rights: 'manager'  },
        {acronym: 'OWN', name: 'Owner',    rights: 'owner'    },
      ].map { |mdl| find_or_create_by(mdl.merge(team_id: team.id)).id }
      where(id: ids)          # return a relation instead of an array...
    end

    def reorder_for(team)
      ranks = team.ranks.sort {|x,y| Right(x.rights) <=> Right(y.rights)}
      ranks.each_with_index do |rank, idx|
        rank.update_attribute(:sort_key, idx + 1)
      end
      self
    end

    def reserve_rank_names
      reserve.map(&:name)
    end

    def reserve_rank_labels
      reserves.map(&:acronym)
    end
  end

  # ----- Instance Methods -----

  private

  def upcase_acronym
    self.acronym = self.acronym.try(:upcase)
  end

  def set_defaults
    return unless self.new_record?
    self.description ||= 'TBD'
    self.rights      ||= 'guest'
    self.sort_key    ||= 0
  end
end

# == Schema Information
#
# Table name: team_ranks
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string
#  acronym     :string
#  description :string
#  rights      :string
#  status      :string
#  sort_key    :integer
#  xfields     :hstore           default({})
#  jfields     :jsonb
#  created_at  :datetime
#  updated_at  :datetime
#
