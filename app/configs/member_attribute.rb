require 'app_config/model'

class MemberAttribute < AppConfig::Model

  model_accessor  :label, :name, :encrypt
  id_attribute    :label

  validates_presence_of  :label, :name

  def default_values
    {
        name:        'TBD',
        encrypt:     false
    }
  end

end
