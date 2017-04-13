require 'rails_helper'

require 'weekly_dates'

class TstKlas
  include WeeklyDates

  attr_reader :year, :quarter, :week
  attr_reader :weekly_rotation_day, :weekly_rotation_time

  def initialize(opts)
    @year                 = opts[:year]                 || 2014
    @quarter              = opts[:quarter]              || 1
    @week                 = opts[:week]                 || 1
    @weekly_rotation_day  = opts[:weekly_rotation_day]  || 'Tue'
    @weekly_rotation_time = opts[:weekly_rotation_time] || '08:00'
  end
end

describe TstKlas do
  def valid_params
    {
      year:    2014,
      quarter: 1,
      week:    1
    }
  end

  let(:klas) { described_class }
  subject    { klas.new(valid_params) }

  describe 'Object Attributes' do
    list = %i(year quarter week weekly_start)
    list.each { |att| it { should respond_to(att) } }
  end

  describe '#weekly_start' do
    context 'with default params' do
      specify { expect(subject.weekly_start).not_to be_nil      }
      specify { expect(subject.weekly_start).to     be_a(Time)  }
      specify { expect(subject.weekly_start.wday).to eq(2)      }
      specify { expect(subject.weekly_start.day).to  eq(31)     }
    end

    context 'updating the day' do
      let(:obj) do
        klas.new(valid_params.merge({weekly_rotation_day: 'Sat'}))
      end
      specify { expect(obj.weekly_start.day).to  eq(4) }
      specify { expect(obj.weekly_start.wday).to eq(6) }
    end

    context 'rotation day on Sunday' do
      let(:obj) do
        klas.new(valid_params.merge({weekly_rotation_day: 'Sun'}))
      end
      specify { expect(obj.weekly_start.day).to  eq(29) }
      specify { expect(obj.weekly_start.wday).to eq(0)  }
    end
  end

  describe '#quarter_for' do
    let(:obj) { subject }
    specify { expect(obj.quarter_for('2014-01-01')).not_to be_nil              }
    specify { expect(obj.quarter_for('2014-01-01')[:year]).to          eq(2014) }
    specify { expect(obj.quarter_for('2014-01-01')[:quarter]).to       eq(1)    }
    specify { expect(obj.quarter_for('2014-01-01')[:week]).to          eq(1)    }
    specify { expect(obj.quarter_for('2013-12-31 06:00')[:year]).to    eq(2013) }
    specify { expect(obj.quarter_for('2013-12-31 06:00')[:quarter]).to eq(4)    }
    specify { expect(obj.quarter_for('2013-12-31 06:00')[:week]).to    eq(13)   }
    specify { expect(obj.quarter_for('2013-12-31 09:00')[:year]).to    eq(2014) }
    specify { expect(obj.quarter_for('2013-12-31 09:00')[:quarter]).to eq(1)    }
    specify { expect(obj.quarter_for('2013-12-31 09:00')[:week]).to    eq(1)    }
    specify { expect(obj.quarter_for('2013-12-31 08:00')[:year]).to    eq(2014) }
    specify { expect(obj.quarter_for('2013-12-31 08:00')[:quarter]).to eq(1)    }
    specify { expect(obj.quarter_for('2013-12-31 08:00')[:week]).to    eq(1)    }
    specify { expect(obj.quarter_for('2014-12-30 07:00')[:year]).to    eq(2014) }
    specify { expect(obj.quarter_for('2014-12-30 07:00')[:quarter]).to eq(4)    }
    specify { expect(obj.quarter_for('2014-12-30 07:00')[:week]).to    eq(13)   }
    specify { expect(obj.quarter_for('2014-12-30 09:00')[:year]).to    eq(2015) }
    specify { expect(obj.quarter_for('2014-12-30 09:00')[:quarter]).to eq(1)    }
    specify { expect(obj.quarter_for('2014-12-30 09:00')[:week]).to    eq(1)    }
  end
end