require 'app_config/collection'

class MemberAttributes < AppConfig::Collection

  def reorder
    to_a.each_with_index do |attr, index|
      attr.position = index + 1
    end
    self
  end

  def set_default_models
    # no-op
  end

end