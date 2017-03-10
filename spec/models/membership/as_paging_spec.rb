require 'rails_helper'

describe Membership::AsPaging do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas }
  end

  describe 'Instance Methods' do
    it { should respond_to :alt_name                  }
    it { should respond_to :has_pagable_phone?        }
    it { should respond_to :has_pagable_email?        }
    it { should respond_to :phone_icon                }
    it { should respond_to :email_icon                }
    it { should respond_to :icon_score                }
  end
end

# == Schema Information
#
# Table name: memberships
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  rights       :string(255)
#  user_id      :integer
#  team_id      :integer
#  rank         :string(255)
#  roles        :text             default("{}"), is an Array
#  xfields      :hstore           default("")
#  created_at   :datetime
#  updated_at   :datetime
#  rights_score :integer          default("0")
#  rank_score   :integer          default("100")
#  role_score   :integer          default("0")
#
