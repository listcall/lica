require 'rails_helper'
require 'parsers/range_parser'

describe Parsers::RangeParser  do
  let(:parser) { Parsers::RangeParser.new }

  describe :start do
    subject { parser.start }

    it { should parse '2014'       }
    it { should parse '2014-Q3'    }
    it { should_not parse 'x'      }
  end

  describe :all do
    subject { parser.all }
    it { should_not parse 'Smith' }
    it { should parse '2014'                 }
    it { should parse '2014..2015'           }
    it { should parse '2014...2015'          }
    it { should parse 'current'              }
    it { should parse 'current..current 2'   }
    it { should parse '2012..current'        }
    it { should parse '2012-q2...current'    }
    it { should parse 'current-3..2016jan'   }
  end
end
