# new_pgr

require 'rails_helper'

describe Inbound::RouteMap do

  let(:klas) { described_class }
  subject    { klas.new        }

  describe 'Attributes' do
    it { should respond_to :context   }
  end

  describe 'Instance Methods' do
    it { should respond_to :default_class           }
    it { should respond_to :set_default_class       }
    it { should respond_to :set_base_module         }
    it { should respond_to :clear_base_module       }
    it { should respond_to :use                     }
    it { should respond_to :use                     }
    it { should respond_to :when                    }
    it { should respond_to :if                      }
    it { should respond_to :unless                  }
    it { should respond_to :handler_for             }
  end

  describe 'Class Methods' do
    specify { expect(klas).to respond_to :config         }
    specify { expect(klas).to respond_to :handler_for    }
    specify { expect(klas).to respond_to :default_class  }
  end

  describe '.setup' do
    it 'generates context elements' do
      klas.config do
        use('KlasName').when { |_inbound| true }
      end
      subject.setup_context
      expect(subject.context).to be_an(Array)
      expect(subject.context.length).to eq(1)
    end
  end

  describe '.handler_for' do
    it 'returns the right class' do
      klas.config do
        use('KlasName').when { |_inbound| true }
      end
      expect(klas.handler_for('inbound_double')).to eq('KlasName')
    end

    it 'evaluates an object argument' do
      klas.config do
        use('Klas1').when { |inbound| inbound.length == 1 }
        use('Klas2').when { |inbound| inbound.length == 2 }
      end
      expect(klas.handler_for('x')).to  eq('Klas1')
      expect(klas.handler_for('xx')).to eq('Klas2')
    end

    it 'returns a default class' do
      klas.config do
        use('Klas1').when { |inbound| inbound.length == 1 }
        use('Klas2').when { |inbound| inbound.length == 2 }
      end
      expect(klas.handler_for('xxx')).to eq(klas.default_class)
    end

    it "works using the 'if' syntax" do
      klas.config do
        use('Klas1').if { |inbound| inbound.length == 1 }
        use('Klas2').if { |inbound| inbound.length == 2 }
      end
      expect(klas.handler_for('xxx')).to eq(klas.default_class)
    end
  end

  context 'using unless' do
    it 'generates context elements' do
      klas.config do
        use('KlasTrue').unless  { |_inbound| true  }
        use('KlasFalse').unless { |_inbound| false }
      end
      expect(klas.handler_for('xxx')).to eq('KlasFalse')
    end
  end
end