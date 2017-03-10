require 'rails_helper'

describe User do

  let(:base_params) do
    pwd = 'hello'
    {
      first_name: 'Joe',
      last_name:  'Smith',
      password:   pwd,
      password_confirmation: pwd
    }
  end

  let(:klas)    { described_class         }
  let(:subject) { klas.new(base_params)   }

  def base_username
    vp = base_params
    "#{vp[:first_name].downcase}#{vp[:last_name][0].downcase}"
  end

  describe 'Object Attributes' do
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name)  }
    it { should respond_to(:user_name)  }
  end

  describe 'Object Creation' do
    it { should be_valid         }

    it 'saves the user to the database' do
      subject.save
      expect(subject).to be_valid
    end
  end

  describe '@user_name' do
    it 'generates on create' do
      subject.save
      expect(subject.user_name).to eq(base_username)
    end

    it 'increments on duplicate usernames' do
      obj1 = described_class.create(base_params)
      expect(obj1.user_name).to eq(base_username)
      obj2 = described_class.create(base_params)
      expect(obj2.user_name).to eq(base_username + '2')
    end
  end

  describe '#full_name' do
    it 'generates a valid string' do
      expect(subject.full_name).not_to be_nil
      expect(subject.full_name).to be_a String
    end

    it 'can be assigned' do
      subject.full_name = 'Joe Smith'
      expect(subject.first_name).to eq('Joe')
      expect(subject.last_name).to  eq('Smith')
    end

    it 'can be updated' do
      @obj = klas.create(base_params)
      @obj.update_attributes(full_name: 'Joe Smith')
      @obj.save
      @obj.reload
      expect(@obj.first_name).to eq('Joe')
      expect(@obj.last_name).to  eq('Smith')
    end

    it 'can be updated' do
      subject.save
      subject.update_attributes('full_name' => 'Joe Smith')
      expect(subject.first_name).to eq('Joe')
      expect(subject.last_name).to  eq('Smith')
    end
  end

  describe '#full_name=' do

    it 'handles a simple name' do
      name = 'Joe Smith'
      subject.full_name = name
      expect(subject.first_name).to eq('Joe')
      expect(subject.last_name).to  eq('Smith')
      expect(subject.full_name).to  eq(name)
    end

    it 'updates a complex name' do
      name = 'Sgt. Joe Barton van den Rijn'
      subject.full_name = name
      expect(subject.title).to       eq('Sgt.')
      expect(subject.first_name).to  eq('Joe')
      expect(subject.middle_name).to eq('Barton')
      expect(subject.last_name).to   eq('van den Rijn')
      expect(subject.full_name).to   eq(name)
    end
  end

  describe 'Associations' do
     it { should respond_to(:teams)              }
     it { should respond_to(:memberships)        }
     it { should respond_to(:emails)             }
     it { should respond_to(:addresses)          }
     it { should respond_to(:phones)             }
     it { should respond_to(:other_infos)        }
     it { should respond_to(:emergency_contacts) }
  end

  describe 'Validations' do
     context 'self-contained' do
       before(:each) { subject.save}
       it { should validate_presence_of(:user_name)               }
       it { should validate_presence_of(:first_name)              }
       it { should validate_presence_of(:last_name)               }
       it { should validate_presence_of(:user_name)               }
       it { should allow_value('xxx_yyy').for(:user_name)         }
     end
     context 'inter-object' do
       before(:each) { subject.save }
       # TODO: bug with shoulda-matchers
       # it { should validate_uniqueness_of(:user_name)             }
     end
  end

  describe '.match_full_name' do
    it 'returns a user when there is a match' do
      @obj1 = FG.create(:user, first_name: 'Joe', last_name: 'Smith')
      @obj2 = User.match_full_name('Joe Smith')
      expect(@obj1).to eq(@obj2)
    end
    it 'creates a user when there is no match' do
      @obj = User.match_full_name('Steve Smith')
      expect(@obj).not_to be_nil
      expect(@obj).to be_valid
      expect(@obj).to be_a User
    end
  end

  describe '.other_infos' do
    it 'should return an empty array' do
      expect(subject.other_infos.length).to eq(0)
    end
    it 'should create other infos' do
      subject.save
      subject.other_infos.create( label: 'x', value: 'y')
      expect(subject.other_infos.length).to eq(1)
    end
  end

  describe '.phones' do
    it 'should return an empty array' do
      expect(subject.phones.length).to eq(0)
    end
    it 'should create other infos' do
      subject.save
      subject.phones.create( number: '650-234-1234')
      expect(subject.phones.length).to eq(1)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  uuid                       :uuid
#  user_name                  :string(255)
#  first_name                 :string(255)
#  middle_name                :string(255)
#  last_name                  :string(255)
#  title                      :string(255)
#  superuser                  :boolean          default("false")
#  developer                  :boolean          default("false")
#  avatar_file_name           :string(255)
#  avatar_content_type        :string(255)
#  avatar_file_size           :integer
#  avatar_updated_at          :integer
#  sign_in_count              :integer          default("0")
#  password_digest            :string(255)
#  remember_me_token          :string(255)
#  forgot_password_token      :string(255)
#  remember_me_created_at     :datetime
#  forgot_password_expires_at :datetime
#  last_sign_in_at            :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#
