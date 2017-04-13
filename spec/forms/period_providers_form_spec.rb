require 'rails_helper'

describe PeriodParticipantsForm do

  def base_params
    {
      names:           'andyl, johnc',
      start:           '2014-01-01 00:00',
      all_day:         true,
      service_id:      1,
      rules:           nil,
    }
  end

  describe 'Object Basics' do

    let(:obj) { described_class.new }

    describe 'Attributes' do
      specify { expect(obj).to respond_to(:rules)       }
      specify { expect(obj).to respond_to(:names)       }
      specify { expect(obj).to respond_to(:start)       }
      specify { expect(obj).to respond_to(:finish)      }
      specify { expect(obj).to respond_to(:all_day)     }
      specify { expect(obj).to respond_to(:service_id)  }
    end

  # describe "All Day Params" do
  #
  #   let(:obj) { described_class.new(base_params) }
  #
  #   specify { expect(obj).to_not be_nil }
  #
  #   it "generates a service" do
  #     svc = Service.create
  #     obj.service_id = svc.id
  #     obj.service.should == svc
  #   end
  #
  #
  # end

    # describe "Accessors" do
    #   specify { expect(obj).to respond_to(:start_time) }
    #   specify { expect(obj).to respond_to(:start_date) }
    # end

    # describe "Methods" do
    #   specify { expect(obj).to respond_to(:event)  }
    #   specify { expect(obj).to respond_to(:submit) }
    #   specify { expect(obj).to respond_to(:save)   }
    # end

    # describe "Object Creation" do
    #
    #   it "is not valid in raw state" do
    #     obj.should_not be_valid
    #   end
    #
    # end

  end

  # describe "#submit" do
  #   let(:obj) { described_class.new }
  #
  #   it "works with valid parameters" do
  #     obj.submit(valid_params)
  #     expect(obj).to be_valid
  #   end
  #
  #   it "works with invalid parameters" do
  #     obj.submit(valid_params.except(:start_date))
  #     expect(obj).to_not be_valid
  #   end
  #
  # end

  # describe "Validations" do
  #    context "self-contained" do
  #      it { should validate_presence_of(:start_date)                  }
  #      it { should     allow_value("2012-01-23").for(:start_date)     }
  #      it { should_not allow_value("2012-21-23").for(:start_date)     }
  #      it { should_not allow_value("2012-72-23").for(:start_date)     }
  #    end
  # end

end

