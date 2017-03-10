require 'rails_helper'

describe Pgr::Action::StiOpRsvp do
  let(:klas) { described_class }
  subject    { klas.new        }

  specify { expect(klas).to_not be_nil }

  describe 'Attributes' do
    it { should respond_to :period_id          }
  end

  describe 'Associations' do
    it { should respond_to :period }
  end

  describe 'Validations' do
    it { should validate_presence_of(:period_id)      }
  end

  describe 'Class Methods' do
    specify { expect(klas).to respond_to :label        }
    specify { expect(klas).to respond_to :about        }
    specify { expect(klas).to respond_to :usage_ctxt   }
    specify { expect(klas).to respond_to :has_period   }
    specify { expect(klas.has_period).to eq(true)      }
    specify { expect(klas).to respond_to :action_for   }
  end

  describe 'Instance Methods' do
    it { should respond_to :reply                   }
    it { should respond_to :label                   }
    it { should respond_to :status_msg              }
    it { should respond_to :email_html_helper       }
    it { should respond_to :email_text_helper       }
    it { should respond_to :phone_helper            }
  end

  describe '.normalize' do
    it 'handles yes' do
      expect(klas.action_for('Y')).to eq('yes')
      expect(klas.action_for('Y this works')).to eq('yes')
      expect(klas.action_for(' Yes this works')).to eq('yes')
      expect(klas.action_for('yes this works')).to eq('yes')
    end

    it 'handles no' do
      expect(klas.action_for('NO')).to eq('no')
      expect(klas.action_for('n nit asdf')).to eq('no')
      expect(klas.action_for(' N nit asdf')).to eq('no')
    end

    it 'handles unrecognized' do
      expect(klas.action_for('qwer asdf')).to eq(nil)
      expect(klas.action_for('qweryes asdfno')).to eq(nil)
    end
  end
end

# == Schema Information
#
# Table name: pgr_actions
#
#  id               :integer          not null, primary key
#  pgr_broadcast_id :integer
#  type             :string
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
