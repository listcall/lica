require 'app_config/model'

class TeamFeature < AppConfig::Model

  model_accessor :label, :status
  id_attribute   :label

  validates_presence_of :label, :status

  validates :status, :format => { :with => /on|off/ }

  def default_values
    {
        status:      'on'
    }
  end

end
