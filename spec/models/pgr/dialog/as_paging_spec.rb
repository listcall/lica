require 'rails_helper'

describe Pgr::Dialog::AsPaging do
  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Object Creation' do
    specify { expect(subject).not_to be_nil }
    specify { expect(subject).to be_a klas }
  end

  describe 'Instance Methods' do
    it { should respond_to :recipient_read_label      }
    it { should respond_to :recipient_has_read?       }
    it { should respond_to :is_participant?           }
    it { should respond_to :other_participant_id      }
    it { should respond_to :posts_link                }
    it { should respond_to :updated_disp              }
    it { should respond_to :comment_icon_for          }
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
#  xfields                  :hstore           default("")
#  jfields                  :jsonb            default("{}")
#  created_at               :datetime
#  updated_at               :datetime
#
