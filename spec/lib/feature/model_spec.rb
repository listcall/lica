require 'rails_helper'
require 'feature/model'

describe Feature::Model do

  def new_model(params = {})
    Feature::Model.new params
  end

  context 'without params' do

    before(:each) { @obj = new_model }

    it 'generates an object' do
      expect(@obj).not_to be_nil
    end

    describe 'Object Attributes' do
      specify { expect(@obj).to respond_to :name                }
      specify { expect(@obj).to respond_to :description         }
      specify { expect(@obj).to respond_to :author              }
      specify { expect(@obj).to respond_to :dependencies        }
      specify { expect(@obj).to respond_to :version             }
    end

    describe 'Default Attributes' do
      specify { expect(@obj.author).not_to be_nil }
      specify { expect(@obj.author).to     be_a String }
    end

    describe 'Object Methods' do
      specify { expect(@obj).to respond_to :id     }
      specify { expect(@obj).to respond_to :to_h   }
    end

  end

  context 'with params' do

    def valid_params
      {
          label:          'x.xyz',
          name:           'XYZ',
          author:         'X440',
          description:    'TBD',
          dependencies:   [],
          version:        '1.0'
      }
    end

    before(:each) { @obj = new_model(valid_params) }

    it 'creates a valid object' do
      expect(@obj).not_to be_nil
      expect(@obj).to be_valid
    end

    it 'returns valid instance variables' do
      expect(@obj.label).to eq(valid_params[:label])
      expect(@obj.name).to  eq(valid_params[:name])
    end

    describe '#id' do

      it 'matches the ID field' do
        expect(@obj.id).to eq(@obj.label)
      end

    end

  end

end
