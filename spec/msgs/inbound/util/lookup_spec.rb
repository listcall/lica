require 'inbound/util/lookup'
require 'rails_helper'

describe Inbound::Util::Lookup do

  let(:team) { FG.create(:team) }
  let(:user) { FG.create(:user)                                           }
  let(:memb) { FG.create(:membership, team_id: team.id, user_id: user.id) }

  let(:klas) { described_class  }
  subject    { klas.new(team)   }

  describe '#initialize' do
    it 'generates an object' do
      expect(subject).not_to be_nil
    end
  end

  describe 'Attributes' do
    it { should respond_to :team }
  end

  describe 'Instance Methods' do
    it { should respond_to :match             }
    it { should respond_to :match_recipient   }
    it { should respond_to :match_recipients  }
  end

  describe '#membership_keys' do
    before(:each) { expect(memb).to_not be_nil }
    it 'generates a list of memberships' do
      result = subject.send :membership_keys
      expect(result).to be_an Array
      expect(result.length).to eq(1)
      tgt = result.first
      expect(tgt[:id]).to eq(memb.id)
      expect(tgt[:type]).to eq('membership')
      expect(user.user_name).to match tgt[:address_regex]
    end

    specify { expect(subject.match(user.user_name)[:id]).to               eq(memb.id)  }
    specify { expect(subject.match("#{user.user_name}-member")[:id]).to   eq(memb.id)  }
    specify { expect(subject.match(user.full_name.gsub(' ','_'))[:id]).to eq(memb.id)  }
  end

  describe '#ranks' do
    it 'generates a list of ranks' do
      keys = team.ranks.pluck(:acronym)
      expect(keys).to be_an Array
      result = subject.send :rank_keys
      expect(result).to be_an Array
      expect(result.length).to eq(keys.length)
      tgt = result.first
      expect(keys.first.downcase).to match tgt[:address_regex]
    end
  end
end
