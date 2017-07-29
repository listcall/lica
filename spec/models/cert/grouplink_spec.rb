require 'rails_helper'

describe Cert::Grouplink do
  let(:klas)        { described_class          }
  let(:base_params) { {}                       }
  let(:subject)     { klas.new(base_params)    }

  describe 'Attributes' do
    # it { should respond_to :team_id            }
    # it { should respond_to :membership_id      }
    # it { should respond_to :status             }
    # it { should respond_to :comment            }
    # it { should respond_to :year               }
    # it { should respond_to :quarter            }
    # it { should respond_to :week               }
  end

  describe 'Associations' do
    it { should respond_to :cert_spec             }
    it { should respond_to :cert_group            }
    # it { should respond_to :cert_specs       }
  end

  # describe 'Object Creation' do
  #   it 'handles object creation' do
  #   it 'handles object creation' do
  #     expect(subject).to be_valid
  #   end
  #
  #   it 'saves the object to the database' do
  #     subject.save
  #     expect(subject).to be_valid
  #   end #
  # end
end

# == Schema Information
#
# Table name: cert_grouplinks
#
#  id            :integer          not null, primary key
#  cert_spec_id  :integer
#  cert_group_id :integer
#  position      :integer
#
