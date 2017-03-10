require 'app_config/collection'

class MemberRoles < AppConfig::Collection

  def set_default_models
    return unless @collection.count == 0
    rl = MemberRole.new(position: 1, label: 'TL',  name: 'Team Leader', description: 'TBD')
    rs = MemberRole.new(position: 1, label: 'SEC', name: 'Secretary',   description: 'TBD', rights: 'owner')
    rw = MemberRole.new(position: 1, label: 'WEB', name: 'Web Master',  description: 'TBD', rights: 'manager' )
    self.add_obj rl, rs, rw
  end

end