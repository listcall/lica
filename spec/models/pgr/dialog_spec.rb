require 'rails_helper'
require 'time'

describe Pgr::Dialog do

  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas  }
  end

  describe 'Attributes' do
    it { should respond_to :recipient_id       }
    it { should respond_to :action_response    }
  end

  describe 'Instance Methods' do
    it { should respond_to :num_posts              }
    it { should respond_to :check_for_first_read_by          }
    it { should respond_to :mark_read_thread       }
    it { should respond_to :mark_posted            }
    it { should respond_to :set_action_response    }
  end

  describe 'Associations' do
    it { should respond_to :broadcast   }
    it { should respond_to :posts       }

    context 'with live objects' do
      it 'references a broadcast' do
        subject.save
        brdcst = subject.create_broadcast
        expect(brdcst).to_not be_nil
        expect(brdcst).to     be_a Pgr::Broadcast
      end
    end

    # it "references a post" do
    #   subject.save
    #   post = subject.posts.create
    #   expect(post).to_not be_nil
    #   expect(post).to     be_a Pgr::Post
    # end
  end

  describe '#mark_read_thread' do
    it 'works for recipient' do
      subject.recipient_id = 22
      subject.save
      subject.mark_read_thread(22)
      expect(subject.recipient_read_at).to_not be_nil
      expect(subject.last_read_by['22']).to_not be_nil
      expect(Time.parse(subject.last_read_by['22'])).to be_a Time
    end

    # it "has idempotent recipient update" do
    #   subject.recipient_id = 22
    #   subject.save
    #   subject.mark_read_thread(22)
    #   time1 = subject.recipient_read_at
    #   time2 = subject.last_read_by["22"]
    #   subject.mark_read_thread(22)
    #   expect(time1).to eq(subject.recipient_read_at)
    #   expect(time2).to_not eq(subject.last_read_by["22"])
    # end

    it 'works for other member' do
      subject.save
      subject.mark_read_thread(22)
      expect(subject.recipient_read_at).to be_nil
      expect(subject.last_read_by['22']).to_not be_nil
      expect(Time.parse(subject.last_read_by['22'])).to be_a Time
    end
  end
end

# == Schema Information
#
# Table name: pgr_dialogs
#
#  id                       :integer          not null, primary key
#  pgr_broadcast_id         :integer
#  recipient_id             :integer
#  recipient_read_at        :datetime
#  unauth_action_token      :string
#  unauth_action_expires_at :datetime
#  action_response          :string
#  xfields                  :hstore           default({})
#  jfields                  :jsonb
#  created_at               :datetime
#  updated_at               :datetime
#
