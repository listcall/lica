require 'rails_helper'

describe MembersHelper do

  let(:team) { FG.create(:team)                     }
  let(:mem)  { FG.create(:membership, team: team)   }

  describe '#rank_name' do
    it 'returns a string' do
      expect(helper.rank_name(mem)).to be_a(String)
      expect(helper.rank_name(mem)).to eq('Active')
    end
  end #.
end