require 'rails_helper'

describe Pgr::Util::GenReply do

  include_context "Integration Environment"

  let(:bcst) do
    bc = Pgr::Broadcast::AsPagingCreate.create(bcst_params)
    Pgr::Util::GenBroadcast.new(bc).generate_all.deliver_all
    bc
  end

  let(:klas)    { described_class                                 }
  let(:subject) { klas.new(bcst.dialogs.first, post_params)       }
  let(:rep_svc) { klas.new(bcst.dialogs.first, post_params)       }

  def bcst_params
    {
      'sender_id'              => sendr.id,
      'short_body'             => 'Hello World',
      'long_body'              => 'Hello Long Body World',
      'email'                  => true,
      'sms'                    => true,
      'recipient_ids'          => [recp1.id],
      'assignments_attributes' => [{'pgr_id' => pagr1.id}]
    }
  end

  def post_params
    {
      author_id:       recp1.id,
      target_id:       sendr.id,
      short_body:      'test reply',
      target_channels: [:email, :phone]
    }
  end

  describe 'Attributes' do
    it { should respond_to :dialog }
    it { should respond_to :params }
  end

  describe 'Methods' do
    it { should respond_to :generate_all }
    it { should respond_to :deliver_all  }
  end

  describe '#initialize' do
    it 'generates a live object' do
      obj = rep_svc
      expect(obj).not_to be_nil
    end
  end

  describe '#generate_all' do
    before(:each) { Pgr::Util::GenBroadcast.new(bcst).generate_all }
    it 'generates a posts and outbounds' do
      expect(Pgr::Post.count).to     eq(1)
      expect(Pgr::Outbound.count).to eq(4)
      rep_svc.generate_all
      expect(Pgr::Post.count).to     eq(3)
      expect(Pgr::Outbound.count).to eq(4)
    end
    it 'is idempotent' do
      expect(Pgr::Post.count).to     eq(1)
      expect(Pgr::Outbound.count).to eq(4)
      rep_svc.generate_all
      rep_svc.generate_all
      expect(Pgr::Post.count).to     eq(3)
      expect(Pgr::Outbound.count).to eq(4)
    end
  end

  describe '#deliver_all' do
    before(:each) { Pgr::Util::GenBroadcast.new(bcst).generate_all }
    it 'delivers messages' do
      rep_svc.generate_all
      rep_svc.deliver_all
    end
  end
end
