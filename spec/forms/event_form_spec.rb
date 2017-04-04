require 'rails_helper'

describe EventForm do

  def valid_params
    {
      team_id:         1,
      typ:             'M',
      title:           'Test',
      location_name:   'TBD',
      start_date:      '2013-12-12',
      finish_date:     '2013-12-12',
    }
  end

  describe 'Object Basics' do

    let(:obj) { described_class.new }

    describe 'Attributes' do
      specify { expect(obj).to respond_to(:title)     }
      specify { expect(obj).to respond_to(:leaders)   }
      specify { expect(obj).to respond_to(:typ)       }
      specify { expect(obj).to respond_to(:lat)       }
    end

    describe 'Accessors' do
      specify { expect(obj).to respond_to(:start_time) }
      specify { expect(obj).to respond_to(:start_date) }
    end

    describe 'Methods' do
      specify { expect(obj).to respond_to(:event)  }
      specify { expect(obj).to respond_to(:submit) }
      specify { expect(obj).to respond_to(:save)   }
    end

    describe 'Object Creation' do

      it 'is not valid in raw state' do
        expect(obj).not_to be_valid
      end

    end

  end

  describe '#submit' do
    let(:obj) { described_class.new }

    it 'works with valid parameters' do
      obj.submit(valid_params)
      expect(obj).to be_valid
    end

    it 'works with invalid parameters' do
      obj.submit(valid_params.except(:start_date))
      expect(obj).to_not be_valid
    end

  end

  describe 'Validations' do
     context 'self-contained' do
       # TODO: fix problem with shoulda-matchers 8-aug-2016
       # it { should validate_presence_of(:start_date)                  }
       # it { should     allow_value('2012-01-23').for(:start_date)     }
       # it { should_not allow_value('2012-21-23').for(:start_date)     }
       # it { should_not allow_value('2012-72-23').for(:start_date)     }
     end
  end

end

