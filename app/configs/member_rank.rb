require 'app_config/model'

class MemberRank < AppConfig::Model

  model_accessor :label, :name, :description, :rights
  id_attribute   :label

  def rights
    return 'owner'   if @rights == 'admin'
    return 'manager' if @rights == 'director'
    @rights
  end

  validates_presence_of :label, :name, :rights

  validates :rights, :format => { :with => /owner|manager|active|reserve|guest|alum|inactive/ }

  def default_values
    {
        description: 'TBD',
        rights:      'active'
    }
  end

  def rank_params
    {
      acronym: label,
      name:    name,
      rights:  rights,
      description: description,
    }
  end
end
