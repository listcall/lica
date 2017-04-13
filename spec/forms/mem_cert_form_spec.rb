require 'rails_helper'

describe MemCertForm do

  def valid_params(opts = {})
    {
      title:           'Test',
      membership_id:   1,
      qual_ctype_id:   1
    }.merge(opts)
  end

  let(:klas)          { described_class          }
  let(:valid_subject) { klas.new(valid_params)   }
  let(:subject)       { klas.new                 }

  describe 'Object Basics' do
    describe 'UsrCert Attributes' do
      specify { expect(subject).to respond_to(:title)      }
      specify { expect(subject).to respond_to(:comment)    }
      specify { expect(subject).to respond_to(:link)       }
      specify { expect(subject).to respond_to(:attachment) }
      specify { expect(subject).to respond_to(:expires_at) }
    end

    describe 'MemCert Attributes' do
      specify { expect(subject).to respond_to(:id)            }
      specify { expect(subject).to respond_to(:membership_id) }
      specify { expect(subject).to respond_to(:qual_ctype_id) }
      specify { expect(subject).to respond_to(:position)      }
    end

    describe 'Methods' do
      specify { expect(subject).to respond_to(:mem_cert)          }
      specify { expect(subject).to respond_to(:usr_cert)          }
      specify { expect(subject).to respond_to(:generate)          }
      specify { expect(subject).to respond_to(:update)            }
      specify { expect(subject).to respond_to(:has_expires?)      }
      specify { expect(subject).to respond_to(:has_link?)         }
      specify { expect(subject).to respond_to(:has_comment?)      }
      specify { expect(subject).to respond_to(:has_attachment?)   }
    end

    describe 'Object Creation' do
      it 'is not valid in raw state' do
        expect(subject).not_to be_valid
      end
      it 'is valid with the subject set' do
        expect(valid_subject).to be_valid
      end
    end

    describe 'Validations' do
      context 'self-contained' do
        # TODO: fix problem with shoulda-matchers 8-aug-2016
        # it { should validate_presence_of(:title)                  }
        # it { should validate_presence_of(:membership_id)          }
        # it { should validate_presence_of(:qual_ctype_id)          }
      end
    end
  end

  describe 'Instance Methods' do
    let(:team) { FG.create(:team)                                 }
    let(:user) { FG.create(:user)                                 }
    let(:mem)  { FG.create(:membership, user: user, team: team)   }
    let(:obj)  { klas.new(valid_params(membership_id: mem.id))    }

    describe '#generate' do
      it 'generates a UsrCert and a MemCert' do
        expect(UserCert.count).to eq(0)
        expect(MembershipCert.count).to eq(0)
        obj.generate
        expect(UserCert.count).to eq(1)
        expect(MembershipCert.count).to eq(1)
        expect(obj.id).to_not be_nil
      end
    end

    describe '#update' do
      before(:each) { obj.generate }
      it 'updates a UsrCert and MemCert' do
        new_params = {title: 'HO HO', id: obj.id, position: 10}
        new_obj = klas.new(valid_params(new_params))
        new_obj.update
        expect(new_obj.mem_cert.position).to eq(10)
        expect(new_obj.mem_cert.title).to eq('HO HO')
      end
    end
  end

  describe 'Private Methods' do
    describe '#assign_attributes' do
      it 'creates a valid object' do
        subject.send(:assign_attributes, valid_params)
        expect(subject).to be_valid
      end
    end

    describe '#mem_attrs' do
      specify { expect(subject.send(:mem_attrs)).to be_a(Hash) }
    end

    describe '#usr_attrs' do
      specify { expect(subject.send(:usr_attrs)).to be_a(Hash) }
      it 'returns a correct attribute value' do
        subject.title = 'asdf'
        expect(subject.send(:mem_attrs)[:title]).to eq('asdf')
      end
    end
  end

end

