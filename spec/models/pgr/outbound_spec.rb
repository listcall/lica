require 'rails_helper'

describe Pgr::Outbound do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Associations' do
    it { should respond_to :post      }
    it { should respond_to :target    }
    it { should respond_to :email     }
    it { should respond_to :phone     }
  end

  describe 'Attributes' do
    it { should respond_to :type         }
    it { should respond_to :read_at      }
    it { should respond_to :sent_at      }
    it { should respond_to :created_at   }
  end

  describe 'Methods' do
    it { should respond_to :sent?     }
    it { should respond_to :deliver   }
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
#  bounced        :boolean          default(FALSE)
#  xfields        :hstore           default({})
#  sent_at        :datetime
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
