require 'rails_helper'
require 'ext/ar_proxy'

describe 'AR Proxy Extensions' do
  let!(:team)     { FG.create :team                   }
  let!(:member)   { FG.create :membership, team: team }
  let(:base_klas) { Membership                        }
  let(:sub_klas)  { Membership::AsPaging              }

  it 'returns the expected class value without the extension' do
    mem = team.memberships.first
    expect(mem).to be_a(base_klas)
  end

  it 'returns the modified class value with the extension' do
    mem = team.memberships.becomes(sub_klas).first
    expect(mem).to be_a(sub_klas)
  end

  it 'returns the original class value' do
    mem = team.memberships.first
    expect(mem).to be_a(base_klas)
  end
end
