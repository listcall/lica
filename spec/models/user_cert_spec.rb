require 'rails_helper'

describe UserCert do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Creation' do
    specify { expect(subject).to be_valid        }
    specify { expect(subject.save).to be_truthy  }
  end

  describe 'Attributes' do
    %i(user_id comment link xfields).each do |attr|
      it { should respond_to(attr) }
    end
  end

  describe 'Associations' do
    %i(user membership_certs).each do |rel|
      it { should respond_to(rel) }
    end
  end
end

# == Schema Information
#
# Table name: user_certs
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  comment                   :string(255)
#  link                      :string(255)
#  attachment_file_name      :string(255)
#  attachment_file_size      :string(255)
#  attachment_content_type   :string(255)
#  attachment_updated_at     :string(255)
#  expires_at                :datetime
#  ninety_day_notice_sent_at :datetime
#  thirty_day_notice_sent_at :datetime
#  expired_notice_sent_at    :datetime
#  xfields                   :hstore           default({})
#  created_at                :datetime
#  updated_at                :datetime
#
