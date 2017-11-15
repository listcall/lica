# require 'forwardable'

class Cert::Profile < ActiveRecord::Base

  self.table_name = 'cert_profiles'

  # extend Forwardable

  # ----- Attributes -----

  # ----- Associations -----
  with_options :touch => true do
    belongs_to :membership
    belongs_to :cert_fact         , class_name: 'Cert::Fact'
    belongs_to :cert_description  , class_name: 'Cert::Description'
  end

  # ----- delegated methods -----

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

end

# == Schema Information
#
# Table name: cert_profiles
#
#  id                  :integer          not null, primary key
#  membership_id       :integer
#  cert_description_id :integer
#  cert_fact_id        :integer
#  title               :string
#  position            :integer
#  status              :string
#  ev_type             :string
#  reviewer_id         :integer
#  reviewed_at         :string
#  external_id         :string
#  xfields             :hstore           default({})
#  mc_expires_at       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
