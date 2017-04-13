require 'rails_helper'

describe TeamFeature do

  def new_team_feature
    FG.build :team_feature
  end

  let(:klas) { described_class }
  subject    { klas.new }

  context 'with no params' do

    before(:each) { @obj = TeamFeature.new }

    it 'works' do
      expect(@obj).not_to be_nil
    end

    describe 'object attributes' do
      list = %i(id label status)
      list.each {|lst| it { should respond_to(lst) }}
    end

    describe 'object validation' do
      # TODO: fix problem with shoulda-matchers 8-aug-2016
      # specify { expect(subject).to validate_presence_of :label    }
      # specify { expect(subject).to validate_presence_of :status   }
      # specify { expect(subject).not_to be_valid }
    end

    describe 'updating attributes' do
      it 'updates using accessor methods' do
        newname = 'ASDF'
        @obj.label = newname
        expect(@obj.label).to eq(newname)
      end

      it 'updates using a params hash' do
        newname = 'ASDF'
        @obj.assign_attributes label: newname
        expect(@obj.label).to eq(newname)
      end
    end

  end

  context 'with params' do

    def valid_params
      {
          label:   'EVENTS',
          status: 'on'
      }
    end

    before(:each) { @obj = TeamFeature.new(valid_params) }

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

    describe '#to_h' do

      it 'matches the input params' do
        expect(@obj.to_h).to eq(@obj.default_values.merge(valid_params.merge({position: 0})))
      end

    end

  end

end
