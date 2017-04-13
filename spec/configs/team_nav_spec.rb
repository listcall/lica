require 'rails_helper'

describe TeamNav do

  def new_team_menu
    FG.build :team_nav
  end

  context 'with no params' do

    before(:each) { @obj = TeamNav.new }

    it 'works' do
      expect(@obj).not_to be_nil
    end

    describe 'object attributes' do
      specify { expect(@obj).to respond_to :id     }
      specify { expect(@obj).to respond_to :uuid   }
      specify { expect(@obj).to respond_to :type   } #
      specify { expect(@obj).to respond_to :path   }
      specify { expect(@obj).to respond_to :label  }
      specify { expect(@obj).to respond_to :position     }
    end

    describe 'object validation' do
      # TODO: fix problem with shoulda-matchers
      # specify { expect(@obj).to validate_presence_of :label     }
      # specify { expect(@obj).to be_valid }
    end

    describe 'updating attributes' do
      it 'updates using accessor methods' do
        newname = 'asdf'
        @obj.label = newname
        expect(@obj.label).to eq(newname)
      end

      it 'updates using a params hash' do
        newname = 'asdf'
        @obj.assign_attributes label: newname
        expect(@obj.label).to eq(newname)
      end
    end
  end

  context 'with params' do

    def valid_params
      {
          type:    'TBD',
          label:   'EVENTS'
      }
    end

    before(:each) { @obj = TeamNav.new(valid_params) }

    describe '#has a generated ID' do
      subject { super().has a generated ID }
      it 'works' do
        expect(@obj.id).to be_a String
        expect(@obj.id).to eq(@obj.uuid)
      end
    end

    it 'creates a valid object' do
      expect(@obj).not_to be_nil
      expect(@obj).to be_valid
    end

    describe '#to_h' do

      it 'matches the input params' do
        expect(@obj.to_h).to be_a Hash
      end
    end
  end
end
