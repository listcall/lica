require 'forwardable'
require 'app_auth/methods'

class Qual < ActiveRecord::Base

  include AppAuth::Methods
  extend Forwardable
  # has_paper_trail

  # ----- Attributes -----
  alias_attribute :rid      ,  :rname
  alias_attribute :abbrev   ,  :rname
  alias_attribute :acronym  ,  :rname

  xfields_accessor :v_rights, :v_ranks, :v_roles, :p_rights, :p_ranks, :p_roles

  # ----- Associations -----
  belongs_to :team              ,  :touch     => true
  has_many   :qual_partnerships ,  :dependent => :destroy
  has_many   :qual_assignments  ,  :dependent => :destroy
  has_many   :qual_ctypes       ,  ->{order(:position)}, :through   => :qual_assignments

  alias_method :assignments ,  :qual_assignments
  alias_method :ctypes      ,  :qual_ctypes

  def required_ctypes
    qry = 'qual_assignments.qual_id = ? AND qual_assignments.status = ?'
    QualCtype.joins(:qual_assignments).where(qry, self.id, 'required')
  end

  # ----- delegated methods -----

  # ----- Validations -----

  # ----- Callbacks -----

  before_save  :instrument_qual

  # ----- Scopes -----

  class << self
    def by_v_rights(team, rights) ; by_field(team, 'v_rights', rights) ; end
    def by_v_ranks(team , ranks)  ; by_field(team, 'v_ranks' , ranks)  ; end
    def by_v_roles(team , roles)  ; by_field(team, 'v_roles' , roles)  ; end
    def by_p_rights(team, rights) ; by_field(team, 'p_rights', rights) ; end
    def by_p_ranks(team , ranks)  ; by_field(team, 'p_ranks' , ranks)  ; end
    def by_p_roles(team , roles)  ; by_field(team, 'p_roles' , roles)  ; end

    private

    # query is a string with values separated by spaces
    def by_field(team, tgt_field, query)
      team_id = team.to_i
      field = "xfields -> '#{tgt_field}'"
      q_sql   = query.split(' ').map do |ele|
        "string_to_array(#{field}, ' ') @> string_to_array('#{ele}', ' ')"
      end.join(' OR ')
      where(team_id: team_id).where(q_sql)
    end
  end

  # ----- Class Methods ----

  class << self
    def defaults_for(team)
      team_id = team.to_i
      return [] if team_id.blank? || team_id == 0
      opts = {team_id: team_id, name: 'Team Certs', rname: 'certs'}
      qual = find_or_create_by(opts)
      [qual]
    end
  end

  # ----- Instance Methods -----

  def instrument_qual
    return unless self.xfields_changed?
    opts = { qual_id: self.id }
    ActiveSupport::Notifications.instrument 'qual_xfields.update', opts
  end

end

# == Schema Information
#
# Table name: quals
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  name       :string(255)
#  rname      :string(255)
#  position   :integer
#  xfields    :hstore           default({})
#  created_at :datetime
#  updated_at :datetime
#
