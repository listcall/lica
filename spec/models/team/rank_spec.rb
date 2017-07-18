require 'rails_helper'

describe Team::Rank do

  let(:klas) { described_class }
  let(:subject) { klas.new     }

  def new_rank
    FG.build :member_rank
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
      it { should respond_to :description  }
      it { should respond_to :sort_key     }
    end

    describe 'object validation' do
      specify { expect(subject).to validate_presence_of :acronym      }
      specify { expect(subject).to validate_presence_of :name         }
      specify { expect(subject).to validate_presence_of :rights       }
      specify { expect(subject).not_to be_valid                       }
    end

    describe 'default values' do
      specify { expect(subject.rights).to eq('guest')                }
      specify { expect(subject.sort_key).to eq(0)                    }
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
          acronym:     'FM',
          name:        'field member',
          rights:      'guest',
          description: 'operates in field',
          sort_key:    1
      }
    end

    let(:subject) { klas.new(valid_params) }

    it 'creates a valid object' do
      expect(subject).not_to be_nil
      expect(subject).to be_valid
    end
  end

  describe '.set_default_for' do
    let(:team) { FG.create(:team) }

    it 'generates default ranks' do
      expect(team).to be_present
      expect(team.ranks.count).to eq(7)
    end

    it 'generates correct ordering' do
      expect(team).to be_present
      expect(team.ranks.find_by(acronym: 'OWN').sort_key).to eq(1)
      expect(team.ranks.find_by(acronym: 'MGR').sort_key).to eq(2)
      expect(team.ranks.find_by(acronym: 'ACT').sort_key).to eq(3)
      expect(team.ranks.find_by(acronym: 'RES').sort_key).to eq(4)
      expect(team.ranks.find_by(acronym: 'GST').sort_key).to eq(5)
      expect(team.ranks.find_by(acronym: 'ALU').sort_key).to eq(6)
      expect(team.ranks.find_by(acronym: 'INA').sort_key).to eq(7)
    end
  end
end

# == Schema Information
#
# Table name: team_ranks
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string
#  acronym     :string
#  description :string
#  rights      :string
#  status      :string
#  sort_key    :integer
#  xfields     :hstore           default({})
#  jfields     :jsonb
#  created_at  :datetime
#  updated_at  :datetime
#
