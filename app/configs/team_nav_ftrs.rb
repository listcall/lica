require 'app_config/collection'

class TeamNavFtrs < AppConfig::Collection

  def set_default_models
    return unless @collection.count == 0

    objs = []
    objs << TeamNav.new( type: '<custom>',   label: 'Admin' , path: '/admin' , manager: 'hide', reserve: 'hide', active: 'hide')
    self.add_obj *objs
    self
  end

end