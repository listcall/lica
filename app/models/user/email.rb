class User::Email < ActiveRecord::Base

  extend UserAttributeProperties

  # ----- Associations -----

  belongs_to   :user, touch: true
  acts_as_list :scope => :user_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_presence_of :address
  validates_format_of   :address, :with => /\A[A-z0-9\-\_\.]+@([A-z0-9\-\_]+\.)+[A-z]+\z/

  validates_uniqueness_of :address

  # ----- Scopes -----
  scope :pagable, -> { where(:pagable => '1') }
  scope :non_standard, -> { where("typ <> 'Work'").
                            where("typ <> 'Home'").
                            where("typ <> 'Personal'").
                            where("typ <> 'Other'") }

  scope :personal, -> { where(:typ => 'Personal').order(:position) }
  scope :home,     -> { where(:typ => 'Home').order(:position) }
  scope :work,     -> { where(:typ => 'Work').order(:position) }
  scope :other,    -> { where(:typ => 'Other').order(:position) }

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id membership_id).each {|a| atts.delete(a)}
    atts
  end

  def pagable?
    self.pagable == '1' || self.pagable == true
  end

  def non_standard_typ?
    ! %w(Work Home Personal Other).include?(typ)
  end

  def output
    extra = pagable? ? '/Pagable' : ''
    "#{address} (#{typ}#{extra})"
  end

  def typ_opts
    base_opts = %w(Personal Work Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

  def email_address
    address
  end

  def email_org
    address.split('@').last.try(:downcase)
  end

end

# == Schema Information
#
# Table name: user_emails
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  typ        :string(255)
#  address    :string(255)
#  pagable    :boolean
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean          default("true")
#
