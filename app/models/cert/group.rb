# require 'forwardable'
# require 'ext/fixnum'

class Cert::Group < ActiveRecord::Base

  self.table_name = "cert_groups"

  # ----- Associations -----
  has_many   :cert_groupties    , class_name: 'Cert::Grouptie'   , foreign_key: "cert_group_id"
  has_many   :cert_defs , class_name: 'Cert::Def', through: :cert_groupties
  belongs_to :team          , :touch => true

  # ----- Delegated Methods -----
  alias_attribute :rname   , :acronym
  alias_attribute :nym     , :acronym
  alias_attribute :abbrev  , :acronym

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  class << self
    def using_attendance
      where(evidence: 'attendance')
    end

    def by_acronym(val)
      where(acronym: val)
    end
  end

  # ----- Instance Methods -----
  def attendance_vals
    self.expirable   = true    if has_attendance?
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
# Table name: cert_groups
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  position   :integer
#  name       :string
#  acronym    :string
#  xfields    :hstore           default({})
#  jfields    :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
