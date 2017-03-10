require 'app_config/collection'

class EventTypes < AppConfig::Collection

  def set_default_models
    return unless @collection.count == 0
    self.add_obj EventType.new(position: 1, acronym: 'M', name: 'Meeting'     )
    self.add_obj EventType.new(position: 1, acronym: 'T', name: 'Training'    )
    self.add_obj EventType.new(position: 1, acronym: 'O', name: 'Operation'   )
    self.add_obj EventType.new(position: 1, acronym: 'C', name: 'Community'   )
  end

end