require 'rails_helper'

describe RecruitForm do

  def valid_params
    {
      team_id:         1,
      rank:            'GST',
      first_name:      'Joe',
      last_name:       'Smith',
      phone_typ:       'Mobile',
      phone_num:       '650-555-1212',
      email_typ:       'work',
      email_adr:       'joe@asdf.com'
    }
  end

  describe 'Object Basics' do
    let(:obj) { described_class.new }

    describe 'Attributes' do
      specify { expect(obj).to respond_to(:rank)          }
    end

    describe 'Methods' do
      specify { expect(obj).to respond_to(:save)  }
    end

    describe 'Object Creation' do
      it 'is not valid in raw state' do
        expect(obj).not_to be_valid
      end
    end
  end

  describe 'Creation with parameters' do
    let(:obj) { described_class.new(valid_params) }

    specify { expect(obj).to be_valid                                }
    specify { expect(obj.rank).to eq(valid_params[:rank])            }
  end

  describe 'Validations' do
    context 'self-contained' do
      # TODO: fix problem with shoulda-matchers
      # it { should     allow_value('650-555-1212').for(:phone_num)     }
      # it { should_not allow_value('650-555-121x').for(:phone_num)     }
    end
  end

  describe '#save' do
    let(:team) { FG.create(:team)                       }
    let(:prms) { valid_params.merge({team_id: team.id}) }
    let(:obj)  { described_class.new(prms)              }

    context 'with no existing users' do
      it 'starts with correct counts' do
        expect(Team.count).to        eq(0)
        expect(User.count).to        eq(0)
        expect(User::Email.count).to eq(0)
        expect(User::Phone.count).to eq(0)
        expect(Membership.count).to  eq(0)
      end

      it 'generates new counts' do
        expect(obj).to be_valid
        expect(Team.count).to        eq(1)
        obj.save
        expect(User.count).to        eq(1)
        expect(User::Email.count).to eq(1)
        expect(User::Phone.count).to eq(1)
        expect(Membership.count).to  eq(1)
      end
    end

    context 'with one existing user' do
      it 'reuses the object' do
        expect(obj).to be_valid
        obj.save
        kk = described_class.new(prms).save
        expect(User.count).to        eq(1)
        expect(User::Email.count).to eq(1)
        expect(User::Phone.count).to eq(1)
        expect(Membership.count).to  eq(1)
      end
    end
  end
end
