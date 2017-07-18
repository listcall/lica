require 'rails_helper'

describe Pgr::Broadcast do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas  }
  end

  describe 'Attributes' do
    it { should respond_to :sender_id }
  end

  describe 'Extended Attributes' do
    it { should respond_to :red_mems  }
    it { should respond_to :clear_mems }
  end

  describe 'Local Methods' do
    # it { should respond_to :mark_posted       }
  end

  describe 'Associations' do
    it { should respond_to :assignments       }
    it { should respond_to :dialogs           }
    it { should respond_to :action            }

    context 'with live objects' do
      it 'creates a live assignment' do
        subject.save
        expect(subject.assignments.count).to eq(0)
        subject.assignments.create
        expect(subject.assignments.count).to eq(1)
      end

      it 'creates a live dialog' do
        subject.save
        expect(subject.dialogs.count).to eq(0)
        subject.dialogs.create
        expect(subject.dialogs.count).to eq(1)
      end
    end
  end

  describe '#outbound_channels' do
    context 'when no flags are set' do
      specify { expect(subject.email).to be_blank }
      specify { expect(subject.sms).to be_blank }
      specify { expect(subject.outbound_channels).to be_blank }
    end
    context 'when the email flag is set' do
      before(:each) { subject.email = true }
      specify { expect(subject.email).to eq(true) }
      specify { expect(subject.outbound_channels).to eq([:email]) }
    end
    context 'when both flags are set' do
      before(:each) { subject.email = true; subject.sms = true }
      specify { expect(subject.email).to eq(true) }
      specify { expect(subject.sms).to eq(true) }
      specify { expect(subject.outbound_channels).to eq([:email, :sms]) }
    end
  end

  describe 'read cache fields' do
    specify { expect(subject.clear_mems).to eq([]) }
    specify { expect(subject.red_mems).to eq([])   }
  end
end

# == Schema Information
#
# Table name: pgr_broadcasts
#
#  id            :integer          not null, primary key
#  sender_id     :integer
#  short_body    :text
#  long_body     :text
#  deliver_at    :datetime
#  recipient_ids :integer          default([]), is an Array
#  xfields       :hstore           default({})
#  jfields       :jsonb
#  created_at    :datetime
#  updated_at    :datetime
#
