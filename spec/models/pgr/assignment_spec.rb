require 'rails_helper'

describe Pgr::Assignment do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas  }
  end

  describe 'Attributes' do
    it { should respond_to :sequential_id                      }
    it { should respond_to :pgr_id                             }
    it { should respond_to :pgr_broadcast_id                   }
  end

  describe 'Associations' do
    it { should respond_to :pgr                }
    it { should respond_to :broadcast          }

    context 'with live objects' do
      it 'creates a live broadcast' do
        subject.save
        bcst = subject.create_broadcast
        expect(bcst).to_not be_nil
        expect(bcst).to     be_a(Pgr::Broadcast)
      end
      it 'creates a live pgr' do
        subject.save
        pgr = subject.create_pgr
        expect(pgr).to_not be_nil
        expect(pgr).to     be_a(Pgr)
      end
    end
  end

  describe '#sequence_id' do
    let(:pgr) { Pgr.create                  }
    let(:asn) { klas.create(pgr_id: pgr.id) }

    it 'generates a valid association' do
      expect(asn.pgr_id).to eq(pgr.id)
      expect(pgr.assignments).not_to be_blank
      expect(pgr.assignments.length).to eq(1)
      expect(pgr.assignments.first).to  be_a klas
    end
    it 'generates a valid sequence_id' do
      expect(asn.sequential_id).not_to be_nil
      expect(asn.sequential_id).to be_an Integer
    end
    it 'generates a sequential number' do
      expect(asn).to_not be_blank
      b2 = klas.create pgr: pgr
      expect(b2.sequential_id).to eq(asn.sequential_id + 1)
    end
  end

end

# == Schema Information
#
# Table name: pgr_assignments
#
#  id               :integer          not null, primary key
#  sequential_id    :integer
#  pgr_id           :integer
#  pgr_broadcast_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#
