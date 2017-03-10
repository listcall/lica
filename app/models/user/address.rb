require 'parsers/address_parser'

class User::Address < ActiveRecord::Base

  extend UserAttributeProperties

  # ----- Associations -----
  belongs_to   :user, touch: true
  acts_as_list :scope => :user_id

  # ----- Callbacks -----

  # ----- Validations -----
  validates_presence_of :zip
  validates_format_of   :zip,
                        :allow_blank => true,
                        :with        => /\A\d\d\d\d\d(\-\d\d\d\d)?\z/

  def has_guest_attribute
    is_guest
  end

  # ----- Scopes -----
  scope :non_standard, -> {
    where("typ <> 'Work'").
    where("typ <> 'Home'").
    where("typ <> 'Other'")
  }

  scope :other,      -> { where(:typ => 'Other').order(:position) }
  scope :home,       -> { where(:typ => 'Home').order(:position) }
  scope :work,       -> { where(:typ => 'Work').order(:position) }


  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id membership_id).each {|a| atts.delete(a)}
    atts
  end

  def display
    dsp_adr1 = address1.blank? ? '' : "#{address1}, "
    dsp_adr2 = address2.blank? ? '' : "#{address2}, "
    dsp_city = city.blank?     ? '' : "#{city} "
    dsp_state = state.blank?   ? '' : "#{state} "
    dsp_zip   = zip.blank?     ? '' : zip
    "#{dsp_adr1}#{dsp_adr2}#{dsp_city}#{dsp_state}#{dsp_zip}"
  end

  def non_standard_typ?
    ! %w(Work Home Other).include?(typ)
  end

  def blank_hash
    hsh = {}
    hsh[:address1] = ''
    hsh[:address2] = ''
    hsh[:city]     = ''
    hsh[:state]    = ''
    hsh[:zip]      = ''
    hsh
  end

  def capitalize_each(string)
    string.split(' ').map {|w| w.capitalize}.join(' ')
  end

  def parse_address(string)
    tmp = Parsers::AddressParser.new.parse(string)
    tmp.keys.each {|key| tmp[key] = tmp[key].to_s}
    blank_hash.merge(tmp)
  end

  def full_address
    @full_addresses || "#{address1.end_nl}#{address2.end_nl}#{city.end_sp}#{state.end_sp}#{zip}"
  end

  def full_address=(input)
    begin
      hash = parse_address(input)
    rescue
      @parse_error = true
      @full_addresses = input
      return
    end
    @parse_error = false
    self.zip      = hash[:zip]
    self.address1 = capitalize_each(hash[:address1])
    self.address2 = capitalize_each(hash[:address2])
    self.city     = hash[:city].length == 2 ? hash[:city].upcase : capitalize_each(hash[:city])
    self.state    = hash[:state].upcase
  end

  def output
    "#{address1.end_br}#{address2.end_br}#{city.end_sp}#{state.end_sp}#{zip.end_sp}(#{typ})"
  end

  def typ_opts
    base_opts = %w(Home Work Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

end

# == Schema Information
#
# Table name: user_addresses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  typ        :string(255)
#  address1   :string(255)      default("")
#  address2   :string(255)      default("")
#  city       :string(255)      default("")
#  state      :string(255)      default("")
#  zip        :string(255)      default("")
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  visible    :boolean          default("true")
#
