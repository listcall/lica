# new_serv

class Position::Partner < ActiveRecord::Base

  acts_as_list :scope => :partner_id, :column => :sort_key

  # ----- attributes -----

  # ----- associations -----
  belongs_to :partner , :class_name => 'Team', :foreign_key => 'partner_id'
  belongs_to :position, touch: true

  alias_method :team, :partner

  # ----- callbacks -----

  # ----- validations -----

  # ----- scopes -----
  scope :sorted, -> { order(:sort_key) }

  # ----- klass methods -----

  # ----- local methods -----

end

# == Schema Information
#
# Table name: position_partners
#
#  id          :integer          not null, primary key
#  position_id :integer
#  partner_id  :integer
#  sort_key    :integer
#  xfields     :hstore           default({})
#  jfields     :jsonb
#  created_at  :datetime
#  updated_at  :datetime
#
