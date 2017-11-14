require 'rails_helper'

describe Cert::Unit do
  let(:klas)        { described_class          }
  let(:base_params) { {}                       }
  let(:subject)     { klas.new(base_params)    }

  describe 'Attributes' do
    it { should respond_to :team_id            }
    it { should respond_to :name               }
    it { should respond_to :acronym            }
    it { should respond_to :expirable          }
    it { should respond_to :commentable        }
    it { should respond_to :xfields            }
    it { should respond_to :ev_types           }
  end

  describe 'Associations' do
    it { should respond_to :team                }
    it { should respond_to :cert_profiles       }
    it { should respond_to :cert_groups         }
    it { should respond_to :cert_groupties      }
  end

  describe 'Object Creation' do
    it 'handles object creation' do
      expect(subject).to be_valid
    end

    it 'saves the object to the database' do
      subject.save
      expect(subject).to be_valid #
    end
  end
end

# == Schema Information
#
# Table name: cert_units
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string
#  acronym     :string
#  expirable   :boolean          default(TRUE)
#  commentable :boolean          default(TRUE)
#  xfields     :hstore           default({})
#  ev_types    :text             default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
