require 'rails_helper'

describe Pgr::Template do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Associations' do
    it { should respond_to :team      }
  end
end

# == Schema Information
#
# Table name: pgr_templates
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  position    :integer
#  name        :string
#  description :string
#  xfields     :hstore           default({})
#  created_at  :datetime
#  updated_at  :datetime
#
