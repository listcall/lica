require 'ext/time'

class EventForm
  include ActiveModel::Model

  # ----- attributes -----

  BASE_KEYS = %i(id event_ref published? all_day? periods start finish all_day published location_name location_address typ team_id title leaders lat lon description tag_list)
  ALT_KEYS  = %i(start_date start_time finish_date finish_time)

  delegate      *BASE_KEYS, :to => :event
  attr_accessor *ALT_KEYS

  def initialize
    day = Time.now.strftime('%Y-%m-%d')
    super
    self
  end

  # ----- validations -----

  DATE_REGEX = /\A20[01][0-9]\-[01][0-9]\-[0123][0-9]\Z/
  TIME_REGEX = /\A[012][0-9]\:[0-5][0-9]\Z/

  validates_presence_of     :start_date  , :finish_date, :title, :typ, :location_name, :team_id
  validates_format_of       :start_date  , with: DATE_REGEX , allow_blank: true
  validates_format_of       :finish_date , with: DATE_REGEX , allow_blank: true
  validates_format_of       :start_time  , with: TIME_REGEX , allow_blank: true
  validates_format_of       :finish_time , with: TIME_REGEX , allow_blank: true
  validates_numericality_of :lat, :allow_nil => true, :greater_than => 30,   :less_than => 43
  validates_numericality_of :lon, :allow_nil => true, :greater_than => -126, :less_than => -113
  validates_format_of   :typ, with: /\A[A-Z]+\z/
  validate :verify_date_order
  validate :verify_lat_lon

  def verify_date_order
    return if start_date.blank? || finish_date.blank?
    if "#{start_date} #{start_time}" > "#{finish_date} #{finish_time}"
      errors.add :finish_time, 'must be on or after start'
    end
  end

  def verify_lat_lon
    return if lat.blank? && lon.blank?
    errors.add :lon, 'is invalid' if lon.blank?
    errors.add :lat, 'is invalid' if lat.blank?
  end

  # ----- active model support -----

  def persisted?; false; end

  # noinspection RubyArgCount
  def self.model_name; ActiveModel::Name.new(self, nil, 'Event'); end

  # ----- instance methods -----

  def with_event(event)
    @event = event
    self
  end

  def event
    @event ||= Event.new
  end

  def submit(params)
    nparams = normalize(params)
    dparams = params_with_defaults(nparams.slice(*BASE_KEYS))
    event.attributes = dparams
    update_event_times(nparams.slice(*ALT_KEYS))
    self
  end

  def update(params)
    nparams = normalize(params)
    base_params = nparams.slice(*BASE_KEYS)
    alt_params  = nparams.slice(*ALT_KEYS)
    event.attributes = base_params unless base_params.blank?
    update_event_times(alt_params) unless alt_params.blank?
    self
  end

  def save
    return false unless valid?
    result = event.save
    if event.periods.count == 0
      Event::Period.create(event_id: event.id, position: 1)
    end
    result
  end

  def start_date  ; @start_date  || event.start.try(:date_part)  ; end
  def start_time  ; @start_time  || event.start.try(:time_part)  ; end
  def finish_date ; @finish_date || event.finish.try(:date_part) ; end
  def finish_time ; @finish_time || event.finish.try(:time_part) ; end

  private

  def normalize(params)
    params.to_h.reduce({}) {|acc, (key, val)| acc[key.to_sym] = val; acc}
  end

  def update_event_times(params)
    params.each { |k, v| instance_variable_set("@#{k}", v) }
    event.start  = "#{start_date} #{start_time}"
    event.finish = "#{finish_date} #{finish_time}"
  end

  def params_with_defaults(params)
    %i(leaders description).each { |key| params[key] ||= 'TBA' }
    params[:published] ||= false
    params[:all_day]   ||= false
    params
  end

end