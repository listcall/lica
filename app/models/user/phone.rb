class User::Phone < ActiveRecord::Base

  extend UserAttributeProperties

  # ----- Associations -----
  belongs_to :user, touch: true

  acts_as_list :scope => :user

  # ----- Callbacks -----
  before_save       :set_pagable

  # ----- Validations -----

  validates_with PhoneUniquenessValidator
  validates_format_of     :number, :with => /\A\d\d\d-\d\d\d-\d\d\d\d\z/

  # ----- Scopes -----
  scope :pagable,      -> { where(:pagable => '1') }
  scope :non_standard, -> { where("typ <> 'Work'").
                            where("typ <> 'Home'").
                            where("typ <> 'Mobile'").
                            where("typ <> 'Pager'").
                            where("typ <> 'Other'") }

  scope :mobile,     -> { where(:typ => 'Mobile').order(:position) }
  scope :home,       -> { where(:typ => 'Home').order(:position) }
  scope :work,       -> { where(:typ => 'Work').order(:position) }

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id membership_id).each {|a| atts.delete(a)}
    atts
  end

  def set_pagable
    self.pagable = 0 unless self.typ.in? %w(Mobile Pager)
  end

  def non_standard_typ?
    ! %w(Work Home Mobile Pager Other).include?(typ)
  end

  def output
    extra = pagable? ? '/Pagable' : ''
    "#{number} (#{typ}#{extra})"
  end

  def pagable?
    self.pagable == '1' || self.pagable == true
  end

  def typ_opts
    base_opts = %w(Mobile Home Work Pager Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

  def email_address
    sms_email
  end

  def email_org
    sms_email.split('@').last.try(:downcase)
  end

  def sanitized_number
    tmp = number.strip.gsub(' ','').gsub('-','')
    return tmp if tmp.length == 11
    '1' + tmp
  end
  alias_method :address, :sanitized_number

end

# == Schema Information
#
# Table name: user_phones
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  typ        :string(255)
#  number     :string(255)
#  pagable    :boolean
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean          default("true")
#
