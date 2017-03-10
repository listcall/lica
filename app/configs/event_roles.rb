require 'app_config/collection'

class EventRoles < AppConfig::Collection

  def set_default_models
    return unless @collection.count == 0
    self.add_obj EventRole.new(position: 1, acronym: 'OL',  name: 'Operation Leader'      )
    self.add_obj EventRole.new(position: 1, acronym: 'AHC', name: 'At Home Coordinator'   )
    self.add_obj EventRole.new(position: 1, acronym: 'TL',  name: 'Training Leader'       )
    self.add_obj EventRole.new(position: 1, acronym: 'LG',  name: 'Logistics'             )
  end

  def position(key)
    keys.index(key)
  end

  def sort_score(key)
    return 0 if key.blank?
    pos = position(key) || 20
    100 - pos
  end

end