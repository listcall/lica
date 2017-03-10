require 'forwardable'

class QualPartnership < ActiveRecord::Base

  extend Forwardable

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :qual  ,  touch: true
  belongs_to :partner     ,  class_name: 'Team', foreign_key: 'partner_id'
  belongs_to :team

  # ----- delegated methods -----

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

end

# == Schema Information
#
# Table name: qual_partnerships
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  partner_id :integer
#  qual_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
