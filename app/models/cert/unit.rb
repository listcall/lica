# require 'forwardable'
# require 'ext/fixnum'

class Cert::Unit < ActiveRecord::Base

  self.table_name = "cert_units"

  # ----- Associations -----
  with_options :dependent => :destroy do
    has_many :cert_profiles , :class_name => 'Cert::Profile'  , foreign_key: "cert_unit_id"#, ->{ order(:position) }
    has_many :cert_groupties, :class_name => 'Cert::Grouptie' , foreign_key: "cert_unit_id"
  end
  has_many   :cert_groups  , :through    => :cert_groupties, class_name: 'Cert::Group'
  belongs_to :team         , :touch      => true

  def certs_for(member)
    membership_certs.includes([:user_cert, :qual_ctype]).where(membership_id: member.id)
  end

  # ----- Delegated Methods -----
  # alias_attribute :rid     , :rname
  alias_attribute :acronym , :rname
  alias_attribute :abbrev  , :rname

  # ----- Validations -----

  # ----- Callbacks -----
  # before_save :attendance_vals

  # ----- Scopes -----

  class << self
    def using_attendance
      where(evidence: 'attendance')
    end
  end

  # ----- Instance Methods -----
  def attendance_vals
    self.expirable   = true    if has_attendance?
    # devlog "UPDATING ATTENDANCE VALS"
  end

  def attendance_val
    opts = JSON.parse(self.attendance_rule || '{}')
    AttendanceVal.new(opts.symbolize_keys)
  end

  def distinct_titles
    self.membership_certs.pluck(:title).sort.uniq << '- add new -'
  end

  def title_select_method
    xfields['title_select_method'] || 'free_text'
  end

  def title_placeholder
    xfields['title_placeholder'] || 'enter title...'
  end

  def has_expires?
    self.expirable
  end

  def has_comment?
    self.commentable
  end

  def has_link?
    self.ev_types.include? 'link'
  end

  def has_file?
    self.ev_types.include? 'file'
  end

  def has_attachment?
    self.ev_types.include? 'file'
  end

  def has_attendance?
    'attendance'.in? self.ev_types
  end

  # ----- Class Methods ----

  class << self
    def defaults_for(team, qual)
      team_id  = team.id
      qual_id  = qual.id
      return [] if [team_id, qual_id].any? {|el| [nil, 0].include?(el)}
      add_types(team, qual, default_qual_ctypes)
    end

    def add_types(team, qual, types)
      team_id  = team.id
      qual_id  = qual.id
      types.map do |hash|
        ctyp = create hash.merge(team_id: team_id)
        QualAssignment.create(qual_id: qual_id, qual_ctype_id: ctyp.id)
        ctyp
      end
    end

    private

    def default_qual_ctypes
      [
        {name: 'CPR-Pro'      , rname: 'CPR'},
      ]
    end
  end


end

# == Schema Information
#
# Table name: cert_units
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string
#  acronym     :string
#  expirable   :boolean          default(TRUE)
#  commentable :boolean          default(TRUE)
#  xfields     :hstore           default({})
#  ev_types    :text             default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
