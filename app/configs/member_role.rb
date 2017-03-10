require 'app_config/model'

class MemberRole < AppConfig::Model

  model_accessor :label, :name, :description, :rights, :has
  id_attribute   :label

  def rights
    return 'owner'   if @rights == 'admin'
    return 'manager' if @rights == 'director'
    @rights
  end

  validates_presence_of     :label, :name, :rights, :has
  validates_inclusion_of    :rights, :in => %w(owner manager active)
  validates_inclusion_of    :has,    :in => %w(one many)

  def default_values
    {
        description: 'TBD',
        rights:      'active',
        has:         'one'
    }
  end

  def role_params
    {
      acronym: label,
      name:    name,
      rights:  rights,
      has:     has,
      description: description,
    }
  end
end
