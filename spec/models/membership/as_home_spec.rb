require 'rails_helper'

describe Membership::AsHome do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas }
  end

  describe 'Instance Methods' do
    it { should respond_to :valid_widgets             }
    it { should respond_to :widget_col1               }
    it { should respond_to :widget_col2               }
  end
end

# == Schema Information
#
# Table name: memberships
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  rights       :string(255)
#  user_id      :integer
#  team_id      :integer
#  rank         :string(255)
#  roles        :text             default("{}"), is an Array
#  xfields      :hstore           default("")
#  created_at   :datetime
#  updated_at   :datetime
#  rights_score :integer          default("0")
#  rank_score   :integer          default("100")
#  role_score   :integer          default("0")
#
