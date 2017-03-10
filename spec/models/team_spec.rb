require 'rails_helper'

describe Team do

  let(:klas)      { described_class             }
  let(:subject)   { klas.new(valid_params)      }
  let(:object)    { klas.create(valid_params)   }
  let(:name)      { 'TeamX'                     }
  let(:subdomain) { 'teamx'                     }
  let(:typ)       { 'field'                     }
  let(:valid_params) do
    {
      name:      name,
      subdomain: subdomain,
      typ:       typ
    }
  end

  describe 'Object Creation' do
    specify { expect(subject).to be_valid }
    specify { expect(object).to be_valid  }
  end

  describe 'Object Attributes' do
    it { should respond_to :typ       }
    it { should respond_to :name      }
    it { should respond_to :acronym   }
    it { should respond_to :subdomain }
    it { should respond_to :altdomain }
    it { should respond_to :logo_text }
    it { should respond_to :_config   }
  end

  describe 'Hstore Attributes' do
    it { should respond_to(:member_roles)  }
    it { should respond_to(:event_roles)   }
  end

  describe 'AppConfig Attributes' do
    it { should respond_to(:member_ranks)       }
    it { should respond_to(:member_ranks=)      }
  end

  describe 'Delegated Methods' do
    it { should respond_to :pager_assignments }
    it { should respond_to :pager_broadcasts  }
  end

  describe 'Associations' do
    it { should respond_to :org           }
    it { should respond_to :users         }
    it { should respond_to :memberships   }
    it { should respond_to :forums        }
    it { should respond_to :pgr           }
    it { should respond_to :pgr_templates }
    it { should respond_to :ranks         }
    it { should respond_to :roles         }
  end

  describe 'Validations' do
    context 'self-contained' do
      it { should validate_presence_of(:name)                   }
      it { should validate_presence_of(:subdomain)              }
      it { should allow_value('field').for(:typ)                }
      it { should allow_value('support').for(:typ)              }
      it { should_not allow_value('zzz').for(:typ)              }
      it { should_not allow_value('z z').for(:acronym)          }
      it { should_not allow_value('z$z').for(:acronym)          }
      it { should     allow_value('z-z').for(:acronym)          }
    end
    context 'inter-object' do
      before(:each) { Team.create!(valid_params) }
      # it { should validate_uniqueness_of(:name)             }
      # it { should validate_uniqueness_of(:subdomain)        }
      # it { should validate_uniqueness_of(:logo_text)        }
    end
    context 'subdomain formatting' do
      it "allows 'zzz'" do
        expect(subject).to be_valid
        subject.subdomain = 'zzz'
        expect(subject).to be_valid
      end
      it "does not allow 'xx xx'" do
        subject.subdomain = 'xx xx'
        expect(subject).not_to be_valid
      end
    end
  end

  describe '#_config' do
    context 'using hstore' do
      it 'takes a hash' do
        hsh = {'x' => 1 }
        subject._config = hsh
        expect(subject._config).to be_a Hash
        expect(subject._config).to eq(hsh)
      end
    end
  end

  describe '#quals' do
    context 'with raw object' do
    specify { expect(subject.quals.length).to eq(0) }
    end

    context 'with saved object' do
      specify { expect(object.quals.length).to eq(1) }
    end
  end

  describe '#qual_ctypes' do
    context 'with raw object' do
    specify { expect(subject.quals.length).to eq(0) }
    end

    context 'with saved object' do
      specify { expect(object.qual_ctypes.length).to eq(1) }
    end
  end

  describe '#ranks' do
    specify { expect(object.ranks(true)).to_not be_blank           }
    specify { expect(object.ranks(true).count).to  eq(7)           }
    specify { expect(object.ranks(true).first).to be_a(Team::Rank) }
  end

  describe '#roles' do
    specify { expect(object.roles(true)).to_not be_blank           }
    specify { expect(object.roles(true).count).to  eq(3)           }
    specify { expect(object.roles(true).first).to be_a(Team::Role) }
  end

  describe 'Duplicate subdomains' do

    context 'within an account' do

      it 'is not valid' do
        @org     = FG.create :org
        @team1   = FG.create :team, org_id: @org.id
        @team2   = FG.build  :team, org_id: @org.id, subdomain: @team1.subdomain
        expect(@team2).not_to be_valid
        @team2.subdomain = 'asdf'
        @team2.acronym   = 'ASDF'
        expect(@team2).to be_valid
      end

    end

    context 'across different accounts' do

      it 'is valid' do
        @org1  = FG.create :org
        @org2  = FG.create :org
        @team1 = FG.create :team, org_id: @org1.id
        @team2 = FG.build  :team, org_id: @org2.id, subdomain: @team1.subdomain
        expect(@team2).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: teams
#
#  id                :integer          not null, primary key
#  uuid              :uuid
#  _config           :json             default("{}")
#  org_id            :integer
#  typ               :string(255)
#  acronym           :string(255)
#  name              :string(255)
#  subdomain         :string(255)
#  altdomain         :string(255)
#  logo_text         :string(255)
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :integer
#  enc_members       :text             default("{}"), is an Array
#  enc_pw_hash       :text
#  created_at        :datetime
#  updated_at        :datetime
#  docfields         :hstore           default("")
#  published         :boolean          default("false")
#
