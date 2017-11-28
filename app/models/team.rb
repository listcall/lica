require 'app_config/accessor'
require 'forwardable'

class Team < ActiveRecord::Base

  extend Enumerize
  extend Forwardable

  has_attached_file :icon

  do_not_validate_attachment_file_type :icon

  # ----- team configurations -----
  config_accessor :team_features
  config_accessor :team_nav_hdrs, :team_nav_ftrs, :team_nav_homes
  config_accessor :member_ranks, :member_roles, :member_attributes
  config_accessor :event_types, :event_roles, :event_attributes
  config_accessor :qual_ctypes

  store_accessor :docfields, :public_website_url, :description
  store_accessor :docfields, :weekly_rotation_day, :weekly_rotation_time

  # ----- Attributes -----
  cattr_accessor :current_id

  enumerize :weekly_rotation_day, in: %w(Mon Tue Wed Thu Fri Sat Sun)

  alias_attribute :rname, :acronym

  # ----- Associations -----
  belongs_to :org

  with_options :dependent => :destroy do
    has_many :memberships
    has_many :events
    has_many :avail_weeks, class_name: 'Avail::Week', foreign_key: 'team_id'
    has_many :quals, -> { order(:position) }
    has_many :qual_ctypes, -> { order(:position) }
    has_many :positions, -> { order(:sort_key) }
    has_many :position_partners, -> { order(:sort_key) }, :foreign_key => :partner_id, :class_name => 'Position::Partner'
    has_many :pgr_templates, -> { order(:position) }, :class_name => 'Pgr::Template'
    has_one :pgr
    has_many :inbounds
    has_many :ranks, -> { order(:sort_key) }, class_name: 'Team::Rank'
    has_many :roles, -> { order(:sort_key) }, class_name: 'Team::Role'
    has_many :cert_defs             , class_name: 'Cert::Def'
    has_many :cert_groups           , class_name: 'Cert::Group'
  end

  has_many :rank_assignments, :through => :ranks, class_name: 'Team::RankAssignment'
  has_many :role_assignments, :through => :roles, class_name: 'Team::RoleAssignment'
  has_many :users, :through => :memberships

  alias_method :members, :memberships

  has_many :event_periods, :through => :events

  has_many :team_partnerships, :dependent => :destroy
  has_many :accepted_partnerships, -> { where(status: 'accepted') }, class_name: 'TeamPartnership'
  has_many :requested_partnerships, -> { where(status: 'requested') }, class_name: 'TeamPartnership'
  has_many :pending_partnerships, -> { where(status: 'pending') }, class_name: 'TeamPartnership'
  has_many :unconfirmed_partnerships, -> { where(status: %w(requested pending)) }, class_name: 'TeamPartnership'

  has_many :all_partners, :through => :team_partnerships, :source => :partner
  has_many :partners, :through => :accepted_partnerships, :source => :partner
  has_many :accepted_partners, :through => :accepted_partnerships, :source => :partner
  has_many :requested_partners, :through => :requested_partnerships, :source => :partner
  has_many :pending_partners, :through => :pending_partnerships, :source => :partner
  has_many :unconfirmed_partners, :through => :unconfirmed_partnerships, :source => :partner

  alias_method :periods, :event_periods

  # ----- Delegated Methods -----
  def_delegator :pgr, :assignments, :pager_assignments
  def_delegator :pgr, :assignments, :pager_broadcasts
  def_delegators :org, :domain, :domain_with_port

  # ----- Validations -----
  validates :typ, :presence => true
  validates :typ, :format => {:with => /support|field/}

  validates_presence_of :acronym, :name, :subdomain, :logo_text
  validates_uniqueness_of :acronym, :name, :subdomain, :logo_text, :scope => :org_id, :case_sensitive => false

  validates_uniqueness_of :altdomain, allow_blank: true, case_sensitive: false
  validates_format_of :altdomain, with: /\Ahttp:\/\//, message: "Must be a valid URL (like 'http://your_domain.com')", allow_blank: true

  validates_format_of :acronym, with: /\A[a-zA-Z0-9\.\-]+\z/, message: 'can only contain letters , numbers or a dash'
  validates_format_of :subdomain, with: /\A[a-zA-Z0-9\.\-]+\z/, message: 'can only contain letters , numbers or a dash'

  validates_with AccountDomainValidator

  # ----- Callbacks -----
  before_validation :set_logo_text
  before_validation :set_default_acronym
  before_validation :set_default_typ

  # ----- Scopes -----
  scope :field, -> { where(typ: 'field').order(:acronym) }
  scope :support, -> { where(typ: 'support').order(:acronym) }
  scope :published, -> { where(published: true).order(:acronym) }

  # ----- Class Methods ----
  def self.by_fqdn(fqdn)
    subdomain, domain = fqdn.split('.', 2)
    res = where(:subdomain => subdomain).joins(:org).merge(Org.by_domain(domain))
    res.to_a.first
  end

  def self.not_partnered_with(team)
    partner_ids = team.all_partners.pluck(:id) + [team.id]
    where('id NOT IN (?)', partner_ids).where(typ: 'field').order(:acronym)
  end

  # ----- association constructors -----

  def pgr
    super.presence || Pgr.find_or_create_by(team: self)
  end

  def quals
    super.presence || Qual.defaults_for(self)
  end

  def qual_ctypes
    super.presence || QualCtype.defaults_for(self, self.quals.first)
  end

  def ranks(reload = false)
    # asdf
    super().presence || Team::Rank.set_defaults_for(self)
  end

  def roles(reload = false)
    super().presence || Team::Role.set_defaults_for(self)
  end

  # ----- Instance Methods -----

  def weekly_rotation_day
    super.presence || 'Tue'
  end

  def weekly_rotation_time
    super.presence || '08:00'
  end

  def to_i
    self.id
  end

  def partnered_with?(team)
    self.partners.pluck(:id).include? team.to_i
  end

  def create_pgr
    Pgr.create(team_id: self.id) if self.pgr.blank?
  end

  def fqdn
    "#{subdomain}.#{org.try(:domain) || 'test.com'}"
  end

  def fqdn_with_port
    "#{subdomain}.#{org.try(:host_with_port)}"
  end

  def set_default_typ
    self.typ ||= 'field'
  end

  def set_default_acronym
    self.acronym ||= self.subdomain.try(:upcase)
  end

  def set_logo_text
    self.logo_text = self.name if self.logo_text.blank?
  end

  def icon_path
    if self.typ == 'support'
      case self.org.typ
        when 'system' then
          '/icons/ac_red.ico'
        when 'hosting' then
          '/icons/ac_green.ico'
        else
          '/icons/ac_blue.ico'
      end
    else
      self.icon.blank? ? '/icons/default.ico' : self.icon.url
    end
  end

  # ----- ranks and role stuff -----

  # TODO: delete after migration
  def reset_membership_assignments
    migrate_ranks_and_roles
    members.all.each do |mem|
      mem.rank_assignments.all.each { |x| x.destroy }
      mem.role_assignments.all.each { |x| x.destroy }
      rank = get_rank(mem.rank)
      mem.update_column(:rank, rank.acronym) if rank.acronym != mem.rank
      raise "BAD RANK #{mem.user_name} / #{mem.rank} / #{acronym}" if rank.blank?
      mem.rank_assignments.create(team_rank_id: rank.id, started_at: Time.now)
      mem.roles.each do |role_acronym|
        role = roles.find_by_acronym(role_acronym)
        if role.blank?
          mem.update_column(:roles, mem.roles - [role_acronym])
          next
        end
        mem.role_assignments.create(team_role_id: role.id, started_at: Time.now)
      end
      mem.reload
      mem.update_rights_and_scores!
    end
  end

  # TODO: delete after migration
  def get_rank(rank)
    ranks.find_by_acronym(rank) ||
      ranks.find_by_rights(:guest) ||
      ranks.find_by_rights(:inactive) ||
      ranks.last
  end

  # TODO: delete after migration
  def get_role(role)
    roles.find_by_acronym(role)
  end

  # TODO: delete after migration
  def migrate_ranks_and_roles
    reset_ranks_and_roles
    member_ranks.to_a.sort { |x| -1 * x.position }.each_with_index do |x, idx|
      Team::Rank.create(x.rank_params.merge({team_id: self.id, sort_key: idx + 1}))
    end
    member_roles.to_a.sort { |x| -1 * x.position }.each_with_index do |x, idx|
      Team::Role.create(x.role_params.merge({team_id: self.id, sort_key: idx + 1}))
    end
  end

  # TODO: delete after migration
  def reset_ranks_and_roles
    ranks.all.each { |x| x.destroy }
    roles.all.each { |x| x.destroy }
  end
end

# == Schema Information
#
# Table name: teams
#
#  id                :integer          not null, primary key
#  uuid              :uuid
#  _config           :json
#  org_id            :integer
#  typ               :string(255)
#  acronym           :string(255)
#  name              :string(255)
#  subdomain         :string(255)
#  altdomain         :string(255)
#  logo_text         :string(255)
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :integer
#  enc_members       :text             default([]), is an Array
#  enc_pw_hash       :text
#  created_at        :datetime
#  updated_at        :datetime
#  docfields         :hstore           default({})
#  published         :boolean          default(FALSE)
#
