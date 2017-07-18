require 'rails_helper'

describe Inbound::StiEmail do

  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Creation' do
    it { should_not be_nil    }
    it { should     be_valid  }
  end

  describe 'Instance Methods' do
    it { should respond_to :reply_dialog_id          }
    it { should respond_to :reply_author_id          }
  end

  describe '#reply_dialog_id' do
    it 'returns a dialog ID' do
      obj = klas.new(headers: {'In-Reply-To' => '<pgr-1-1@asdf.com>'})
      expect(obj.reply_dialog_id).to eq('1')
    end
  end

  # describe "#reply_author_id" do
  #   let!(:team) { FG.create(:team)                      }
  #   let!(:usr)  { FG.create(:user_with_phone_and_email) }
  #   let!(:mem)  { FG.create(:membership, team_id: team.id, user_id: usr.id) }
  #   let!(:obj)  { klas.new(team_id: team.id, fm: usr.emails.first.address) }
  #
  #   it "returns a Membership id" do
  #     expect(obj.reply_author_id).to eq(mem.id)
  #   end
  # end
end

# == Schema Information
#
# Table name: inbounds
#
#  id               :integer          not null, primary key
#  team_id          :integer
#  pgr_dialog_id    :integer
#  type             :string
#  proxy            :string
#  subject          :string
#  fm               :string
#  to               :string           default([]), is an Array
#  headers          :hstore           default({})
#  text             :text
#  destination_type :string
#  destination_id   :integer
#  xfields          :hstore           default({})
#  created_at       :datetime
#  updated_at       :datetime
#
