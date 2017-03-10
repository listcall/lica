require 'rails_helper'

describe Pgr::Outbound::StiPhone do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Class Methods' do
    specify { expect(klas).to respond_to :sms_match }
  end

  describe 'Instance Methods' do
    it { should respond_to :deliver            }
    it { should respond_to :get_origin_number  }
    it { should respond_to :action_footer }
  end

  describe '.sms_match' do
    let(:obj) { klas.sms_match(qry) }

    context 'with no params' do
      let(:qry) { {} }
      it 'returns an empty set' do
        expect(obj.to_a).to eq([])
      end
    end

    context 'when given extra params' do
      let(:qry) { {mem_num: '1', svc_num: '2', extra: 3} }

      it 'raises an error' do
        expect { obj.to_a }.to raise_error
      end
    end

    context 'when missing a param' do
      let(:qry) { {mem_num: '1'} }

      it 'works' do
        expect(obj.to_a).to eq([])
      end
    end

    context 'when there is no match' do
      it 'returns an empty set' do
        result = klas.sms_match.to_a
        expect(result).to be_an Array
        expect(result).to be_empty
      end
    end
  end

  describe "#get_origin_number" do
  end
end

# == Schema Information
#
# Table name: pgr_outbounds
#
#  id             :integer          not null, primary key
#  type           :string
#  pgr_post_id    :integer
#  target_id      :integer
#  device_id      :integer
#  device_type    :string
#  target_channel :string
#  origin_address :string
#  target_address :string
#  bounced        :boolean          default("false")
#  xfields        :hstore           default("")
#  sent_at        :datetime
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
