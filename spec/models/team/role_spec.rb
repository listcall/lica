require 'rails_helper'

describe Team::Role do

  let(:klas) { described_class }
  let(:team) { FG.create :team }
  let(:subject) { klas.new     }

  def new_role
    FG.build :role
  end

  context 'with no params' do
    it 'works' do
      expect(subject).not_to be_nil
    end

    describe 'object attributes' do
      it { should respond_to :id           }
      it { should respond_to :acronym      }
      it { should respond_to :name         }
      it { should respond_to :rights       }
      it { should respond_to :has          }
      it { should respond_to :description  }
      it { should respond_to :sort_key     }
    end

    describe 'object validation' do
      specify { expect(subject).to validate_presence_of :acronym       }
      specify { expect(subject).to validate_presence_of :name          }
      specify { expect(subject).not_to be_valid                        }
    end

    describe 'default values' do
      specify { expect(subject.sort_key).to    eq(0)          }
      specify { expect(subject.description).to eq('TBD')      }
      specify { expect(subject.rights).to      eq('active')   }
      specify { expect(subject.has).to         eq('one')      }
    end

    describe 'updating attributes' do
      it 'updates using accessor methods' do
        newname = 'asdf'
        subject.name = newname
        expect(subject.name).to eq(newname)
      end

      it 'updates using a params hash' do
        newname = 'asdf'
        subject.assign_attributes name: newname
        expect(subject.name).to eq(newname)
      end
    end
  end

  context 'with params' do

    def valid_params
      {
          team:        team,
          acronym:     'WEB',
          name:        'web master',
          description: 'manages website',
          rights:      'active',
          sort_key:    1
      }
    end

    let(:subject) { klas.new(valid_params) }

    it 'creates a valid object' do
      expect(subject).not_to be_nil
      expect(subject).to be_valid
    end

    it 'saves the object' do
      subject.save
      expect(subject).to be_valid
      expect(subject.id).to be_present
    end

    # it "updates the object" do
    #   subject.save
    #   subject.name = "ASDF"; subject.save
    #   # expect(subject).to be_valid
    #   expect(subject.id).to be_present
    # end

    describe 'default values' do
      specify { expect(subject.sort_key).to    eq(1)          }
      specify { expect(subject.rights).to      eq('active')   }
      specify { expect(subject.has).to         eq('one')      }
    end
  end
end

# == Schema Information
#
# Table name: team_roles
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string
#  acronym     :string
#  description :string
#  rights      :string
#  status      :string
#  has         :string
#  sort_key    :integer
#  xfields     :hstore           default("")
#  jfields     :jsonb            default("{}")
#  created_at  :datetime
#  updated_at  :datetime
#
