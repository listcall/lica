require 'rails_helper'

describe Pgr::Action::StiOpReturnHome do
  let(:klas) { described_class }
  subject    { klas.new        }

  specify { expect(klas).to_not be_nil }

  describe 'Attributes' do
    it { should respond_to(:period_id) }
  end

  describe 'Associations' do
    it { should respond_to(:period) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:period_id) }
  end

  describe 'Class Methods' do
    specify { expect(klas).to respond_to :label        }
    specify { expect(klas).to respond_to :about        }
    specify { expect(klas).to respond_to :usage_ctxt   }
    specify { expect(klas).to respond_to :has_period   }
  end

  describe 'Instance Methods' do
    it { should respond_to :email_footer_html     }
    it { should respond_to :email_footer_text     }
    it { should respond_to :phone_footer          }
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
