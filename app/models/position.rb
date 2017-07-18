require 'app_ext/pkg'
require 'weekly_dates'

class Position < ActiveRecord::Base
  extend Forwardable
  include WeeklyDates
  acts_as_list :scope => :team_id, :column => :sort_key

  # ----- attributes -----
  def_delegators  :team, :weekly_rotation_day, :weekly_rotation_time
  def_delegators  :role, :name, :acronym, :description

  # ----- associations -----
  belongs_to :team, touch: true
  belongs_to :team_role, class_name: 'Team::Role', foreign_key: 'team_role_id'

  alias_method :role, :team_role

  with_options :dependent => :destroy do
    has_many   :periods , :class_name => 'Position::Period'
    has_many   :partners, :class_name => 'Position::Partner'
  end

  # ----- callbacks -----

  # ----- validations -----

  # ----- scopes -----
  scope :sorted, -> { order(:sort_key) }

  # ----- klass methods -----

  # ----- local methods -----
  def partner_acronyms
    @acro_list ||= partners.map {|p| p.team.acronym}.sort
  end

  def partner_acronyms=(list)
    delete_list = partner_acronyms - list
    create_list = list - partner_acronyms
    create_list.each do |acro|
      team_id = team.partners.find_by_acronym(acro).id
      partners.find_or_create_by(partner_id: team_id)
    end
    delete_list.each do |acro|
      partners.each {|part| part.destroy if part.team.acronym == acro}
    end
  end

end

# == Schema Information
#
# Table name: positions
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  team_role_id :integer
#  sort_key     :integer
#  xfields      :hstore           default({})
#  jfields      :jsonb
#  created_at   :datetime
#  updated_at   :datetime
#
