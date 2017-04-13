require 'spec_helper'
require 'task_sort'

describe TaskSort do

  let(:tasks0)  { {a: [], b: [:a], c: [:b]}                                   }
  let(:tasks1)  { {t1: %i(a b c), t2: %i(t1)}                                 }
  let(:tasks2)  { {t1: %i(a b c), t2: %i(t1), a: [], b: [], c: []}            }
  let(:klas)    { described_class            }
  let(:subject) { klas.new                   }

  describe 'Object Attributes' do
    it { should respond_to(:root_tasks)        }
    it { should respond_to(:root_tasks=)       }
  end

  describe 'Object Creation' do
    it 'works with empty input data' do
      sorter = klas.new
      expect(sorter.tsort).to eq([])
    end
    it 'works with input data' do
      sorter = klas[tasks0]
      expect(sorter.tsort).to eq(tasks0.keys)
    end
  end

  describe '#root_tasks=' do
    let(:obj) { klas[tasks0] }
    let(:tgt) { [:a]         }

    it 'handles no input' do
      expect(obj.root_tasks).to eq(tasks0.keys)
    end

    it 'handles array input' do
      obj.root_tasks = %i(a)
      expect(obj.root_tasks).to eq(tgt)
    end

    it 'handls symbol input' do
      obj.root_tasks = :a
      expect(obj.root_tasks).to eq(tgt)
    end

    it 'handles string input' do
      obj.root_tasks = 'a'
      expect(obj.root_tasks).to eq(tgt)
    end

    it 'handles string arrays' do
      obj.root_tasks = ['a']
      expect(obj.root_tasks).to eq(tgt)
    end
  end

  describe 'task sets' do
    context 'fully-defined' do
      it 'renders the tree' do
        expect(klas[tasks2].tsort).to eq(%i(a b c t1 t2))
      end
    end
    context 'undefined leaves' do
      it 'raises an error' do
        expect { klas[tasks1].tsort }.to raise_exception
      end
    end
  end
end

