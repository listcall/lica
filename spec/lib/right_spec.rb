require 'spec_helper'
require 'right'

describe Right do

  let(:klas)    { described_class            }
  let(:subject) { klas.new                   }

  describe 'Object Methods' do
    it { should respond_to(:value)           }
    it { should respond_to(:value=)          }
    it { should respond_to(:<=>)             }
    it { should respond_to(:<)               }
    it { should respond_to(:>)               }
    it { should respond_to(:to_s)            }
    it { should respond_to(:to_sym)          }
  end

  describe 'Class Methods' do
    specify { expect(klas).to respond_to(:options)        }
  end

  describe 'Object Creation' do
    specify { expect(klas.new).to_not be_nil                      }
    specify { expect(klas.new).to be_a(klas)                      }
    specify { expect(klas.new('active').value).to eq('active')    }
    specify { expect(klas.new(:active).value).to eq('active')     }
    specify { expect { klas.new(:xxx) }.to raise_exception        }
  end

  describe 'Default Values' do
    specify { expect(klas.new.value).to eq('guest')   }
  end

  describe 'Right.options' do
    specify { expect(klas.options).to be_an(Array) }
  end

  describe 'Right Conversion Function' do
    specify { expect(Right(:alum)).to be_a(klas)                       }
    specify { expect(Right(Right(:alum))).to be_a(klas)                }
    specify { expect(Right(Right('alum'))).to be_a(klas)               }
  end

  describe 'Comparisons' do
    specify { expect(Right.new).to eq(Right.new)                         }
    specify { expect(Right(:owner)).to be > Right(:alum)                 }
    specify { expect(Right(:alum)).to be == Right(:alum)                 }
    specify { expect(Right(:alum)).to be < Right(:owner)                 }
  end

  describe 'Score' do
    specify { expect(Right(:owner).score).to    eq(1) }
    specify { expect(Right(:inactive).score).to eq(7) }
  end

  describe 'Comparable' do
    let(:list) { %w(guest owner reserve).map {|x| Right(x) } }
    it 'sorts' do
      expect(list.sort.map(&:value)).to eq(%w(guest reserve owner))
    end

    it 'finds max' do
      expect(list.max.value).to eq('owner')
    end

    it 'finds min' do
      expect(list.min.value).to eq('guest')
    end
  end
end
