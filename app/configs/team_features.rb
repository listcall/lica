require 'app_config/collection'
require 'feature/collection'

class TeamFeatures < AppConfig::Collection
  def default_models
    list = Feature::Collection.new.default_models.map {|mdl| mdl.label}
    list.map.reduce([]) {|acc, lbl| acc << TeamFeature.new(label: lbl); acc}
  end

  def set_default_models
    return unless @collection.count == 0
    set_default_models!
  end

  def set_default_models!
    self.set_obj *(default_models)
    self
  end
end