require 'rails_helper'

describe Pgr::Action::StiNone do
  let(:klas) { described_class }
  subject    { klas.new        }

  specify { expect(klas).to_not be_nil }

end

# == Schema Information
#
# Table name: pgr_actions
#
#  id               :integer          not null, primary key
#  pgr_broadcast_id :integer
#  type             :string
#  xfields          :hstore           default({})
#  created_at       :datetime
#  updated_at       :datetime
#
