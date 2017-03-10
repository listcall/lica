require 'rails_helper'

describe Pgr::Broadcast::AsPagingCreate do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas }
  end

  describe 'Attributes' do
    it { should respond_to :sender_id }
  end

  describe 'Associations' do
    it { should respond_to :pgrs               }
    it { should respond_to :assignments        }
    it { should respond_to :dialogs            }
    it { should respond_to :action             }

    it 'creates a live assignment' do
      subject.save
      expect(subject.assignments.count).to eq(0)
      subject.assignments.create
      expect(subject.assignments.count).to eq(1)
      expect(subject.assignments.first).to be_a(Pgr::Assignment::AsPagingCreate)
    end

    it 'creates a live assignment using nested parameters' do
      team   = FG.create(:team)
      pgr    = team.pgr
      params = {assignments_attributes: [{pgr_id: pgr.id}] }
      obj = klas.create(params)
      expect(obj).to be_a klas
      expect(obj).to be_present
      expect(obj.pgrs.length).to eq(1)
    end

    it 'creates a live dialog' do
      subject.save
      expect(subject.dialogs.count).to eq(0)
      subject.dialogs.create
      expect(subject.dialogs.count).to eq(1)
      expect(subject.dialogs.first).to be_a(Pgr::Dialog::AsPaging)
    end
  end

  it 'creates a live action' do
    subject.save
    expect(subject.action).to be_nil
    subject.create_action
    expect(subject.action).to be_a(Pgr::Action)
  end

  it 'creates a live action using nested parameters' do
    type   = 'Pgr::Action::StiOpRsvp'
    params = {action_attributes: {type: type, period_id: 1}}
    obj = klas.create(params)
    expect(obj.action).to_not be_nil
    expect(obj.action.type).to eq(type)
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
#  recipient_ids :integer          default("{}"), is an Array
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
