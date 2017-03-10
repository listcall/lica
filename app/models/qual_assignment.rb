require 'forwardable'

class QualAssignment < ActiveRecord::Base

  extend Forwardable

  # ----- Attributes -----

  # ----- Associations -----
  with_options :touch => true do
    belongs_to :qual
    belongs_to :qual_ctype
  end

  alias_method :ctype, :qual_ctype

  # ----- delegated methods -----
  def status
    super || 'optional'
  end

  # ----- Validations -----

  # ----- Callbacks -----

  after_create   :instrument_create
  before_destroy :instrument_destroy

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

  def instrument_create
    instrument('qual_assignment.create')
  end

  def instrument_destroy
    instrument('qual_assignment.destroy')
  end

  def instrument(tag)
    opts = {qual_id: qual.try(:id), qual_assignment_id: self.id}
    ActiveSupport::Notifications.instrument tag, opts
  end

  def required?
    self.status == 'required'
  end

end

# == Schema Information
#
# Table name: qual_assignments
#
#  id            :integer          not null, primary key
#  qual_id       :integer
#  qual_ctype_id :integer
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
