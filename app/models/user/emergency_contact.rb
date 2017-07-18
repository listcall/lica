class User::EmergencyContact < ActiveRecord::Base

  extend UserAttributeProperties

  # ----- Associations -----
  belongs_to   :user, touch: true
  acts_as_list :scope => :user_id

  # ----- Callbacks -----

  # ----- Validations -----
  validates_presence_of :name, :phone_number
  validates_format_of :phone_number, :with => /\A\d\d\d-\d\d\d-\d\d\d\d\z/
  validates_format_of :phone_type,   :with => /\A(Mobile|Home|Work|Other)\z/

  # ----- Scopes -----


  # ----- Local Methods-----
  def full_contact
    return name if kinship.blank?
    "#{name} / #{kinship}"
  end


  def export
    atts = attributes
    %w(id membership_id).each {|a| atts.delete(a)}
    atts
  end

  def output
    "#{name} / #{number} (#{typ})"
  end

end

# == Schema Information
#
# Table name: user_emergency_contacts
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  name         :string(255)
#  kinship      :string(255)
#  phone_number :string(255)
#  phone_type   :string(255)
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  visible      :boolean          default(TRUE)
#
