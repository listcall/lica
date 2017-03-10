require 'rails_helper'

describe Pgr::Outbound::StiEmail do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Attributes' do
    it { should respond_to :action_footer_html }
    it { should respond_to :action_footer_text }
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
#  bounced        :boolean          default("false")
#  xfields        :hstore           default("")
#  sent_at        :datetime
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#
