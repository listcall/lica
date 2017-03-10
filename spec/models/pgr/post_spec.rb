require 'rails_helper'

describe Pgr::Post do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Attributes' do
    it { should respond_to :action_response           }
  end

  describe 'Associations' do
    it { should respond_to :dialog                                }
    it { should respond_to :broadcast                             }

    context 'with live object' do
      it 'generates a dialog' do
        subject.target_channels = [:email]
        subject.save
        dial = subject.create_dialog
        expect(dial).to_not be_nil
        expect(dial).to     be_a Pgr::Dialog
      end
    end
  end

  describe 'Instance Methods' do
    it { should respond_to :set_action_response    }
  end

  describe 'Hstore Attributes' do
    it { should respond_to :author_action     }
  end

  describe 'Delegated Methods' do
    it { should respond_to :sender    }
    it { should respond_to :recipient }
  end

  describe 'Scopes' do
    specify { expect(klas).to respond_to :for_dialog  }
    specify { expect(klas).to respond_to :actions     }
    specify { expect(klas).to respond_to :msgs        }
  end

  describe '#target_channels' do
    it 'returns an array of symbols' do
      input = %w(email)
      subject.target_channels = input
      expect(subject.target_channels).to eq(input)
    end
  end

end

# == Schema Information
#
# Table name: pgr_posts
#
#  id              :integer          not null, primary key
#  type            :string
#  pgr_dialog_id   :integer
#  author_id       :integer
#  target_id       :integer
#  short_body      :text
#  long_body       :text
#  action_response :string
#  bounced         :boolean          default("false")
#  ignore_bounce   :boolean          default("false")
#  sent_at         :datetime
#  read_at         :datetime
#  xfields         :hstore           default("")
#  jfields         :jsonb            default("{}")
#  created_at      :datetime
#  updated_at      :datetime
#
