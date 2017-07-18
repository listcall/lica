require 'rails_helper'

describe Membership do

  let(:base_params) do
    {
      user_id:       1,
      team_id:       1,
      rank:          'MEM'
    }
  end

  let(:klas)    { described_class            }
  let(:subject) { klas.new(base_params)      }
  specify { expect(subject).to be_valid      }

  before(:each) do
    allow_any_instance_of(klas).to receive(:update_credentials)
    allow_any_instance_of(klas).to receive(:setup_credentials)
  end

  describe 'Object Attributes' do
    it { should respond_to :user_id           }
    it { should respond_to :team_id           }
    it { should respond_to :rank              }
    it { should respond_to :roles             }
    it { should respond_to :rights            }
    it { should respond_to :rank_score        }
    it { should respond_to :role_score        }
    it { should respond_to :rights_score      }
    it { should respond_to :cert_assignments  }
    it { should respond_to :xfields           }
  end

  describe 'Xfield Attributes' do
    it { should respond_to :time_button           }
    it { should respond_to :editor_keystyle       }
    it { should respond_to :owner_plus            }
  end

  describe 'Associations' do
    it { should respond_to(:user)            }
    it { should respond_to(:team)            }
    it { should respond_to(:created_pages)   }
    it { should respond_to(:created_posts)   }
    it { should respond_to(:created_topics)  }
    it { should respond_to(:assigned_topics) }
  end

  describe 'Instance Methods' do
    it { should respond_to :to_i                        }
    it { should respond_to :ordered_roles               }
    it { should respond_to :update_rights_and_scores!   }
  end

  describe 'Delegated Methods' do
    it { should respond_to :user_name                   }
  end

  describe 'Object Creation' do
    it 'saves the object to the database' do
      subject.save
      expect(subject).to be_valid
    end

    it 'creates memberships with factories' do
      @user = create :user
      @team = create :team
      @mobj = create :membership, user_id:@user.id, team_id:@team.id
      expect(@mobj).to be_valid
      expect(@mobj.team).to eq(@team)
      expect(@mobj.user).to eq(@user)
    end
  end

  describe 'Validations' do
    context 'self-contained' do
      it { should validate_presence_of(:user_id)              }
      it { should validate_presence_of(:team_id)              }
      it { should validate_presence_of(:rank)                 }
    end
  end

  describe 'Role Manipulation' do
    it 'updates a whole array' do
      expect(subject.roles).to eq([])
      subject.roles = %w(A B C)
      expect(subject.roles).to eq(%w(A B C))
    end
    it 'handles concatenation' do
      subject.roles << 'A'
      expect(subject.roles).to eq(['A'])
    end
    it 'handles deletion' do
      subject.roles = %w(A B C)
      subject.roles.delete('B')
      expect(subject.roles).to eq(%w(A C))
    end
  end

  describe '#time_button - default value' do
    specify { expect(subject.time_button).to eq('none') }
  end

  describe '#roles' do
    before(:each) do
      @team = create :team
      @mem  = create :membership, team_id: @team.id
    end

    it 'returns an array' do
      expect(@mem.roles).to be_empty
      expect(@mem.roles).to be_an Array
    end

    it 'updates the array with a role' do
      @mem.roles = ['UL']
      @mem.save ; @mem.reload
      expect(@mem.roles).to eq(['UL'])
      @mem.roles += ['BD']
      @mem.save ; @mem.reload
      expect(@mem.roles).to eq(%w(UL BD))
      @mem.roles = []
      expect(@mem.roles).to eq([])
    end
  end

  describe '.by_user_name' do
    before(:each) do
      @team = create :team
      @user = create :user
      @mem  = create :membership, team_id: @team.id, rank: 'MEM', user_id: @user.id
    end
    it 'retrieves the username' do
      user = @team.memberships.by_user_name(@user.user_name)
      expect(user).not_to be_nil
      expect(user.to_a).not_to be_nil
      expect(user.to_a).to be_an Array
      expect(user.to_a.length).to eq(1)
    end
  end

  describe '.by_id_or_user_name' do
    before(:each) do
      @team = create :team
      @user = create :user
      @mem  = create :membership, team_id: @team.id, rank: 'MEM', user_id: @user.id
    end

    it 'finds a member by id' do
      mem = @team.memberships.by_id_or_user_name(@mem.id)
      expect(mem).not_to be_blank
      expect(mem.first).to be_a Membership
      expect(mem.first).to eq(@mem)
    end

    it 'finds a member by user_name' do
      mem = @team.memberships.by_id_or_user_name(@mem.user.user_name)
      expect(mem).not_to be_blank
      expect(mem).to be_an Array
      expect(mem.first).to be_a Membership
      expect(mem.first).to eq(@mem)
    end
  end
end

# == Schema Information
#
# Table name: memberships
#
#  id           :integer          not null, primary key
#  uuid         :uuid
#  rights       :string(255)
#  user_id      :integer
#  team_id      :integer
#  rank         :string(255)
#  roles        :text             default("{}"), is an Array
#  xfields      :hstore           default("")
#  created_at   :datetime
#  updated_at   :datetime
#  rights_score :integer          default("0")
#  rank_score   :integer          default("100")
#  role_score   :integer          default("0")
#
