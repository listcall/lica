require 'forwardable'
require 'app_ext/pkg'
require 'ext/string'
require 'right'

class Membership < ActiveRecord::Base

  extend Forwardable
  extend Enumerize

  # ----- Attributes -----

  VALID_RIGHTS = Right.options
  enumerize :rights, in: VALID_RIGHTS, default: 'guest', predicates: true, scope: true

  xfield_accessor :owner_plus

  xfield_accessor :sign_in_count, default: 0
  xfield_accessor :last_sign_in_at

  xfield_accessor :time_button
  enumerize :time_button    , in: %w(transit signin none), default: 'none'

  xfield_accessor :editor_keystyle
  enumerize :editor_keystyle, in: %w(vim emacs notepad)  , default: 'notepad'

  # upcase_fields :rank, :roles

  # ----- Associations -----
  belongs_to  :user, touch: true
  belongs_to  :team, touch: true
  with_options :dependent => :destroy do
    # has_many    :forum_subscriptions
    # has_many    :forum_topic_subscriptions
    # has_many    :membership_certs
    has_many    :participations   , class_name: 'Event::Participant'
    has_many    :avail_days       , class_name: 'Avail::Day'
    has_many    :avail_weeks      , class_name: 'Avail::Week'
    has_many    :rank_assignments , class_name: 'Team::RankAssignment'
    has_many    :role_assignments , class_name: 'Team::RoleAssignment'
    has_many    :cert_assignments
  end

  has_many :zdays, ->(start, finish) { between(start, finish) }, class_name: 'Avail::Day'

  has_many    :team_ranks      , :through => :rank_assignments
  has_many    :team_roles      , :through => :role_assignments

  has_many    :created_pages   , :class_name => 'PagerBroadcast' , :foreign_key => 'author_id'
  has_many    :created_posts   , :class_name => 'Posts'          , :foreign_key => 'creator_id'
  has_many    :created_topics  , :class_name => 'Topics'         , :foreign_key => 'creator_id'
  has_many    :assigned_topics , :class_name => 'Topics'         , :foreign_key => 'assignee_id'

  has_many    :svc_participations , :class_name => 'Svc::Participant', :foreign_key => 'membership_id', :dependent => :destroy

  # ----- Delegated Methods -----
  def_delegators :user, :user_name,  :full_name, :first_name, :last_name,
                        :avatar,     :emails,     :phones,    :user_certs,
                        :addresses,  :emergency_contacts

  # ----- Validations -----
  validates_presence_of  :user_id, :team_id, :rank
  validates_inclusion_of :rights, in: VALID_RIGHTS

  # ----- Callbacks -----
  after_create   :setup_credentials
  before_save    :update_credentials
  before_destroy :user_destroy

  # ----- Scopes -----
  scope :owner   , -> { where(rights: ['owner'])}
  scope :manager , -> { where(rights: ['owner', 'manager'])}
  scope :active  , -> { where(rights: ['owner', 'manager', 'active'])}
  scope :reserve , -> { where(rights: ['owner', 'manager', 'active', 'reserve'])}
  scope :guest   , -> { where(rights: ['owner', 'manager', 'active', 'reserve', 'guest'])}

  scope :reserve_only, -> { where(rights: 'reserve') }
  scope :guests_only , -> { where(rights: 'guest')   }

  scope :with_attr      , ->(key)  { where('xfields ? :key', :key => key)  }
  scope :in_role        , ->(role) { where("'#{role}' = any(roles)")       }
  scope :by_sort_score  , -> { by_role_score.by_rank_score.by_rights_score }
  scope :by_rights_score, -> { order('rights_score DESC') }
  scope :by_role_score  , -> { order('role_score DESC') }
  scope :by_rank_score  , -> { order('rank_score ASC')}
  scope :standard_order , -> { by_sort_score }

  scope :with_avatar, -> do
    joins(:user).where('users.avatar_file_name IS NOT NULL')
  end
  scope :sans_avatar, -> do
    joins(:user).where('users.avatar_file_name IS NULL')
  end
  scope :by_last_name, -> do
    joins(:user).order('users.last_name ASC').order('users.first_name ASC')
  end
  scope :by_user_name, ->(name) do
    joins(:user).where('users.user_name ilike ?', name)
  end

  def self.find_as_sorted(ids)
    values = []
    ids.each_with_index do |id, index|
      values << "(#{id}, #{index + 1})"
    end
    relation = self.joins("JOIN (VALUES #{values.join(",")}) as x (id, ordering) ON #{table_name}.id = x.id")
    relation = relation.order('x.ordering')
    relation
  end

  # ----- Class Methods -----
  def self.by_id_or_user_name(input)
    result = if input.is_a?(Numeric) || input.is_integer?
      find(input)
    else
      by_user_name(input)
    end
    Array(result)
  end

  # ----- Instance Methods -----
  def to_i
    self.id
  end

  # ----- Ranks, Roles, Rights, Scores -----
  def take_role=(acronym)
    acro = acronym.upcase
    others = team.memberships.in_role(acro)
    others.each do |mem|
      next if mem.id == self.id
      next unless mem.roles.include?(acro)
      mem.roles.delete(acro)
      mem.save
    end
    return if self.roles.include?(acro)
    self.roles << acro
    self.save
  end


  def ordered_roles
    team.roles.order(:sort_key).pluck(:acronym) & roles
  end

  # this is a utility method - to facility migrate
  # TODO: remove at some point
  def update_rights_and_scores!
    credentials_svc.setup
    self.save if self.changed?
  end
  alias_method :uras!, :update_rights_and_scores!

  private

  def setup_credentials
    credentials_svc.setup
    self.save if self.changed?
  end

  def update_credentials
    credentials_svc.update
  end

  def credentials_svc
    @credentials_svc ||= Member::CredentialsSvc.new(self)
  end

  def user_destroy
    user.destroy if user && user.memberships.length == 1
  end
end

# == Schema Information
#
# Table name: memberships
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  rights       :string(255)
#  user_id      :integer
#  team_id      :integer
#  rank         :string(255)
#  roles        :text             default("{}"), is an Array
#  xfields      :hstore           default("")
#  created_at   :datetime
#  updated_at   :datetime
#  rights_score :integer          default("0")
#  rank_score   :integer          default("100")
#  role_score   :integer          default("0")
#
