require 'app_config/model'

class EventAttribute < AppConfig::Model

  model_accessor :label, :name, :encrypt
  id_attribute   :label

  validates_presence_of :label, :name

  def default_values
    {
        name:        'TBD',
        label:       'TBD',
        encrypt:     false
    }
  end

end
