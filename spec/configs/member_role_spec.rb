require 'rails_helper'

describe MemberRole do

  def new_member_role
    FG.build :member_role
  end

  context 'with no params' do

    before(:each) { @obj = MemberRole.new }

    it 'works' do
      expect(@obj).not_to be_nil
    end

    describe 'object attributes' do
      specify { expect(@obj).to respond_to :id     }
      specify { expect(@obj).to respond_to :label   }
      specify { expect(@obj).to respond_to :name   }
      specify { expect(@obj).to respond_to :rights }
      specify { expect(@obj).to respond_to :has    }
      specify { expect(@obj).to respond_to :description  }    #
      specify { expect(@obj).to respond_to :position     }
    end

    describe 'object validation' do
      # TODO: fix problem with shoulda-matchers
      # specify { expect(@obj).to validate_presence_of :label     }
      # specify { expect(@obj).to validate_presence_of :name     }
      # specify { expect(@obj).to validate_presence_of :position }
      # specify { expect(@obj).to validate_numericality_of :position }
      # specify { expect(@obj).not_to be_valid }
    end

    describe 'default values' do
      specify { expect(@obj.position).to    eq(0)          }
      specify { expect(@obj.description).to eq('TBD')      }
      specify { expect(@obj.rights).to      eq('active') }
      specify { expect(@obj.has).to         eq('one')      }
    end

    describe 'updating attributes' do
      it 'updates using accessor methods' do
        newname = 'asdf'
        @obj.name = newname
        expect(@obj.name).to eq(newname)
      end

      it 'updates using a params hash' do
        newname = 'asdf'
        @obj.assign_attributes name: newname
        expect(@obj.name).to eq(newname)
      end
    end

  end

  context 'with params' do
    def valid_params
      {
        label:       'WEB',
        name:        'web master',
        description: 'manages website',
        position: 1
      }
    end

    before(:each) { @obj = MemberRole.new(valid_params) }

    describe '#id matches label' do
      subject { super().id matches label }
      it 'works' do
        expect(@obj.id).to eq(@obj.label)
      end
    end

    it 'creates a valid object' do
      expect(@obj).not_to be_nil
      expect(@obj).to be_valid
    end

    describe 'default values' do
      specify { expect(@obj.position).to    eq(1)          }
      specify { expect(@obj.rights).to      eq('active')   }
      specify { expect(@obj.has).to         eq('one')      }
    end

    describe '#to_h' do
      it 'matches the input params' do
        expect(@obj.to_h).to eq(@obj.default_values.merge(valid_params))
      end
    end
  end
end
