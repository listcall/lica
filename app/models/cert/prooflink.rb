# require 'forwardable'

class Cert::Prooflink < ActiveRecord::Base

  self.table_name = 'cert_prooflinks'

  # extend Forwardable

  # ----- Attributes -----

  # ----- Associations -----
  with_options :touch => true do
    belongs_to :membership
    belongs_to :cert_proof    , class_name: 'Cert::Proof'
    belongs_to :cert_spec     , class_name: 'Cert::Spec'
  end

  # alias_method :ctype, :qual_ctype

  # ----- delegated methods -----
  # def status
  #   super || 'optional'
  # end

  # ----- Validations -----

  # ----- Callbacks -----

  # after_create   :instrument_create
  # before_destroy :instrument_destroy

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

  # def instrument_create
  #   instrument('qual_assignment.create')
  # end

  # def instrument_destroy
  #   instrument('qual_assignment.destroy')
  # end

  # def instrument(tag)
  #   opts = {qual_id: qual.try(:id), qual_assignment_id: self.id}
  #   ActiveSupport::Notifications.instrument tag, opts
  # end

  # def required?
  #   self.status == 'required'
  # end

end
