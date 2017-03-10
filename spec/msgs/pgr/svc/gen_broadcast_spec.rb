require 'rails_helper'

describe Pgr::Util::GenBroadcast do

  let(:team1) { FG.create(:team) }
  let(:team2) { FG.create(:team) }
  let(:user0) { FG.create(:user_with_phone_and_email) }
  let(:user1) { FG.create(:user_with_phone_and_email) }
  let(:user2) { FG.create(:user_with_phone_and_email) }
  let(:user3) { FG.create(:user_with_phone_and_email) }
  let(:sendr) { FG.create(:membership, team_id: team1.id, user_id: user0.id) }
  let(:recv1) { FG.create(:membership, team_id: team1.id, user_id: user1.id) }
  let(:recv2) { FG.create(:membership, team_id: team1.id, user_id: user2.id) }
  let(:recv3) { FG.create(:membership, team_id: team2.id, user_id: user3.id) }
  let(:bcst1) { Pgr::Broadcast.create(bcst1_params)                          }
  let(:bcst2) { Pgr::Broadcast.create(bcst2_params)                          }

  let(:klas)    { described_class }
  let(:subject) { klas.new(1)     }

  def bcst1_params
      {
        'sender_id'              => sendr.id,
        'short_body'             => 'Hello World',
        'long_body'              => 'Hello Long Body World',
        'email'                  => true,
        'phone'                  => true,
        'recipient_ids'          => [recv1.id],
      }
  end

  def bcst2_params
    bcst1_params.merge({'recipient_ids' => [recv1.id, recv2.id]})
  end

  describe 'Attributes' do
    it { should respond_to :broadcast }
  end

  describe 'Methods' do
    it { should respond_to :generate_all }
    it { should respond_to :deliver_all  }
  end

  describe '#initialize' do
    it { should_not be_nil }
    it 'stores the broadcast' do
      obj = klas.new(bcst1)
      expect(obj.broadcast).to eq(bcst1)
    end
  end

  describe 'generate' do
    context 'with one recipient' do
      let(:obj) { klas.new(bcst1) }

      describe 'dialogs' do
        it 'creates objects' do
          expect(Pgr::Dialog.count).to    eq(0)
          obj.send(:generate_dialogs)
          expect(Pgr::Dialog.count).to    eq(1)
        end
        it 'is idempotent' do
          expect(Pgr::Dialog.count).to    eq(0)
          obj.send(:generate_dialogs)
          obj.send(:generate_dialogs)
          expect(Pgr::Dialog.count).to    eq(1)
        end
      end

      describe 'posts' do
        it 'creates objects' do
          expect(Pgr::Post.count).to eq(0)
          obj.send(:generate_dialogs)
          obj.send(:generate_posts)
          expect(Pgr::Post.count).to eq(1)
        end
        it 'is idempotent' do
          expect(Pgr::Post.count).to eq(0)
          obj.send(:generate_dialogs)
          obj.send(:generate_posts)
          obj.send(:generate_dialogs)
          obj.send(:generate_posts)
          expect(Pgr::Post.count).to eq(1)
        end
      end

      describe 'outbounds' do
        it 'creates objects' do
          expect(Pgr::Outbound.count).to eq(0)
          obj.generate_all
          expect(Pgr::Outbound.count).to eq(4)
        end

        it 'is idempotent' do
          expect(Pgr::Outbound.count).to eq(0)
          obj.generate_all
          obj.generate_all
          expect(Pgr::Outbound.count).to eq(4)
        end
      end

      describe 'accessors' do
        it 'generates arrays' do
          obj.generate_all
          expect(obj.dialogs).to   be_an(Array)
          expect(obj.posts).to     be_an(Array)
          expect(obj.outbounds).to be_an(Array)
          expect(obj.outbounds.first).to respond_to(:deliver)
        end
      end

      context 'with two recipients' do
        let(:obj) { klas.new(bcst2) }
        it 'generates two dialogs' do
          obj.generate_all
          expect(Pgr::Dialog.count).to eq(2)
        end
      end
    end
  end

  describe 'deliver' do
    let(:obj) { klas.new(bcst1) }
    it 'delivers messages' do
      obj.generate_all
      obj.deliver_all
    end
  end
end
