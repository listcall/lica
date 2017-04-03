require 'app_config/model'

# add accessors and id_attribute for testing...
class TestId < AppConfig::Model
  model_accessor :field2, :field1
  id_attribute   :field1

  def default_values
    {
        field1: 'ASDF',
        field2: 'qwer'
    }
  end
end

# add accessors and id_attribute for testing...
class TestUuid < AppConfig::Model
  model_accessor :field1, :field2
  id_uuid

  def default_values
    {
        field1: 'ASDF',
        field2: 'qwer'
    }
  end
end

# simple factory for building test models...
FactoryGirl.define do

  factory :app_model, class: TestId do
    sequence :field1 do |n| "x#{n}" end
    sequence :field2 do |n| "y#{n}" end
  end

end