class Event < ActiveRecord::Base

  has_ancestry :orphan_strategy => :rootify

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :team, :touch => true

  has_many   :periods     , -> { order(:position).order(:created_at) }, :dependent => :destroy
  has_many   :participants, :through   => :periods

  # ----- Callbacks -----
  before_save       :update_event_ref
  before_save       :instrument_event
  before_validation :set_cases
  before_validation :adjust_start_finish
  before_validation :save_signature

  # ----- Validations -----
  validates_presence_of :title, :location_name, :start, :finish

  validates_uniqueness_of :signature, :message => 'duplicate record (title, location, start)'

  validates_numericality_of :lat, :allow_nil => true, :greater_than => 30,   :less_than => 43
  validates_numericality_of :lon, :allow_nil => true, :greater_than => -126, :less_than => -113

  validates_format_of       :typ, with: /\A[A-Z]+\z/, allow_blank: true

  validate :lat_lon
  validate :start_before_finish

  def lat_lon
    return if self.lat.nil? && self.lon.nil?
    errors.add :lon, 'is invalid' if self.lon.blank?
    errors.add :lat, 'is invalid' if self.lat.blank?
  end

  def start_before_finish
    return if self.finish.nil? || self.finish.blank?
    errors[:start] << 'must happen before finish' if self.finish < self.start
  end

  # ----- Scopes -----
  scope :published,     -> { where(published: true).order(:start)     }
  scope :unpublished,   -> { where(published: false).order(:start)    }

  scope :trainings      ,  -> { where(typ: 'T') }   # FIXME: delete this
  scope :operations     ,  -> { where(typ: 'O') }   # FIXME: delete this
  scope :meetings       ,  -> { where(typ: 'M') }   # FIXME: delete this
  scope :communities    ,  -> { where(typ: 'C') }   # FIXME: delete this

  scope :ordered, -> { order('start') }

  scope :kind   , ->(typ)  { where(:typ => typ).order(:start)                  }
  scope :by_kind, ->(typ)  { where(:typ => typ).order(:start)                  }
  scope :after  , ->(date) { where('start >= ?', self.date_parse(date))        }
  scope :before , ->(date) { where('start <= ?', self.date_parse(date))        }
  scope :between, ->(start, fin)   { after(start).before(fin).order(:start)    }
  scope :current, ->(t = Time.now) { where('start <= ? AND finish >= ?', t, t) }

  scope :in_year, ->(date) do
    between(date.at_beginning_of_year, date.at_end_of_year)
  end
  scope :on_day, ->(date) do
    start  = self.date_parse(date)
    finish = start + 1.day
    between(start, finish)
  end

  scope :upcoming, -> do
    time = Time.now
    start  = time
    finish = upcoming_finish(time)
    between(start, finish).where.not('start <= ? AND finish >= ?', time, time)
  end
  scope :recent, -> do
    time = Time.now
    start  = recent_start(time)
    finish = time
    between(start, finish).where.not('start <= ? AND finish >= ?', time, time)
  end

  def self.recent_start(t = Time.now)    t - 6.weeks; end
  def self.upcoming_finish(t = Time.now) t + 6.weeks; end

  # Date can be a string in the format 'Jan-2001' or a Time object.
  def self.date_parse(date)
    date.class == String ? Time.parse(date) : date
  end

  def self.tag_uniq
    where.not(tags: []).pluck(:tags).flatten.sort.uniq # FIXME: use database
  end

  # ----- Instance Methods -----
  def instrument_event
    return unless self.start_changed?
    opts = { event_id: self.id }
    ActiveSupport::Notifications.instrument 'event_start.update', opts
  end

  def tag_list
    self.tags.flatten.sort.uniq.map {|x| x.downcase}.join(', ')
  end

  def tag_list=(array)
    self.tags = array.sort.uniq.map {|x| x.downcase}
  end

  def typ_name
    team.event_types[self.typ].try(:name) || self.typ || 'TBD'
  end

  def fq_path
    team.fqdn
  end

  private

  # ----- start / finish
  def set_cases
    self.typ = self.typ.try(:upcase)
    self.tags = self.tags.map {|x| x.downcase}
  end

  def adjust_start_finish
    set_full_dates if self.all_day
  end

  def set_full_dates
    start_date  = to_date(self.start)
    finish_date = to_date(self.finish) || to_date(self.start)
    self.start  = start_date
    self.finish = "#{finish_date} 23:59"
  end

  def to_date(val)
    return nil if val.blank?
    val.strftime('%Y-%m-%d')
  end

  # ----- event reference / email address / etc.
  def update_event_ref
    return unless typ_changed? || start != start_was
    team = self.team
    return if team.blank?
    typ  = self.typ.blank? ? '-' : self.typ
    date = self.start.strftime('%y%b%d')
    mtch = "#{date}#{typ}%"
    aref = team.events.where('event_ref LIKE ?', mtch).pluck(:event_ref)
    seqm = aref.blank? ? 1 : aref.map { |ref| ref.split(/[A-Z\-]/).last.to_i}.max + 1
    self.event_ref = "#{date}#{typ}#{seqm}"
  end

  # ----- signature

  # These fields uniquely identify a record.
  def signature_fields
    "#{self.team_id}/#{self.title}/#{self.location_name}/#{self.start}"
  end

  # The digest is a MD5 digest generated from the signature_fields.
  def digest_signature
    Digest::MD5.hexdigest(signature_fields)
  end

  # The digest field is checked to ensure it is unique.
  # This eliminates the possibility of duplicate records.
  def save_signature
    self.signature = digest_signature
  end

end

# == Schema Information
#
# Table name: events
#
#  id                       :integer          not null, primary key
#  event_ref                :string(255)
#  team_id                  :integer
#  typ                      :string(255)
#  title                    :string(255)
#  leaders                  :string(255)
#  description              :text
#  location_name            :string(255)
#  location_address         :string(255)
#  lat                      :decimal(7, 4)
#  lon                      :decimal(7, 4)
#  start                    :datetime
#  finish                   :datetime
#  all_day                  :boolean          default(TRUE)
#  published                :boolean          default(FALSE)
#  xfields                  :hstore           default({})
#  external_id              :string(255)
#  signature                :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  ancestry                 :string(255)
#  event_periods_count      :integer          default(0), not null
#  event_participants_count :integer          default(0), not null
#  tags                     :text             default([]), is an Array
#
