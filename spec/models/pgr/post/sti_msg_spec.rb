require 'rails_helper'

describe Pgr::Post::StiMsg do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    it 'puts the right value into the type field' do
      subject.save
      expect(subject.type).to eq(klas.to_s)
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
