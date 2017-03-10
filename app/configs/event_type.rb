require 'app_config/model'

class EventType < AppConfig::Model

  TIME_REGEX = /\A[012][0-9]\:[0-5][0-9]\Z/

  # ----- attributes -----

  model_accessor :acronym, :name, :description, :use_transit, :use_signin
  model_accessor :default_start_time, :default_finish_time
  model_accessor :max_periods
  id_attribute   :acronym

  # ----- validations -----

  validates_presence_of  :acronym, :name
  validates_inclusion_of :max_periods,         :in   => %w(one many)
  validates_format_of    :default_start_time,  :with => TIME_REGEX
  validates_format_of    :default_finish_time, :with => TIME_REGEX
  validates_format_of    :acronym            , :with => /\A[A-Z]+\z/
  validate :ordering
  validate :duplicate

  # def upcase_acronym
  #   self.acronym = self.acronym.try(:upcase)
  # end

  def ordering
    errors.add :default_start_time, 'must be before finish' if default_start_time > default_finish_time
  end

  def duplicate
    return if @collection_obj.nil?
    errors.add :name,    'must be unique' if @collection_obj.locate_all('name',    name).length > 1
    errors.add :acronym, 'must be unique' if @collection_obj.locate_all('acronym', acronym).length > 1
  end

  # ----- instance methods -----

  def default_values
    {
        name:                  'TBD',
        acronym:               'TBD',
        description:           'TBD',
        use_transit:           true,
        use_signin:            true,
        default_start_time:    '09:00',
        default_finish_time:   '17:00',
        max_periods:           'many',
    }
  end

  def use_transit?
    [true, 'true'].include? use_transit
  end

  def use_signin?
    [true, 'true'].include? use_signin
  end

end
