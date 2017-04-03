require 'rails_helper'
require 'un_avails'

describe UnAvails do

  let(:team)    { FG.create(:team)                    }
  let(:mem1)    { FG.create(:membership, team: team)  }
  let(:mem2)    { FG.create(:membership, team: team)  }
  let(:members) { [mem1, mem2]                        }
  let(:klas)    { described_class                     }
  let(:subject) { klas.new(members)                   }

  describe 'Object Attributes' do
    it { should respond_to(:member)                   }
    it { should respond_to(:members)                  }
    it { should respond_to(:start)                    }
    it { should respond_to(:finish)                   }
  end

  describe "Object Methods" do
    it { should respond_to :for                       }
    it { should respond_to :busy_on?                  }
    it { should respond_to :return_date               }
    it { should respond_to :current_comment           }
  end
end

