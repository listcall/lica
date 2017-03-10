require 'app_config/model'

class EventRole < AppConfig::Model

  model_accessor :acronym, :name, :description
  id_attribute   :acronym

  validates_presence_of :acronym, :name

  def default_values
    {
        name:        'TBD',
        acronym:     'TBD',
        description: 'TBD',
    }
  end

end
