class RolesMigration < ActiveRecord::Migration[5.1]

  def change
    create_table 'team_ranks' do |t|
      t.integer 'team_id'
      t.string  'name'
      t.string  'acronym'
      t.string  'description'
      t.string  'rights'        # owner  | manager | active | reserve | etc.
      t.string  'status'        # active | archived
      t.integer 'sort_key'
      t.hstore  'xfields',   default: {}
      t.jsonb   'jfields',   default: {}
      t.timestamps
    end
    add_index :team_ranks, :team_id
    add_index :team_ranks, :acronym
    add_index :team_ranks, :rights
    add_index :team_ranks, :status
    add_index :team_ranks, :sort_key
    add_index :team_ranks, :xfields, :using => :gin
    add_index :team_ranks, :jfields, :using => :gin

    create_table 'team_rank_assignments' do |t|
      t.integer  'team_rank_id'
      t.integer  'membership_id'
      t.datetime 'started_at'
      t.datetime 'finished_at'
      t.hstore   'xfields',    default: {}
      t.jsonb    'jfields',    default: {}
      t.timestamps
    end
    add_index :team_rank_assignments, :team_rank_id
    add_index :team_rank_assignments, :membership_id
    add_index :team_rank_assignments, :started_at
    add_index :team_rank_assignments, :finished_at
    add_index :team_rank_assignments, :xfields, :using => :gin
    add_index :team_rank_assignments, :jfields, :using => :gin

    create_table 'team_roles' do |t|
      t.integer 'team_id'
      t.string  'name'
      t.string  'acronym'
      t.string  'description'
      t.string  'rights'         # owner  | manager | active
      t.string  'status'         # active | archived
      t.string  'has'            # one | many
      t.integer 'sort_key'
      t.hstore  'xfields',   default: {}
      t.jsonb   'jfields',   default: {}
      t.timestamps
    end
    add_index :team_roles, :team_id
    add_index :team_roles, :acronym
    add_index :team_roles, :rights
    add_index :team_roles, :status
    add_index :team_roles, :sort_key
    add_index :team_roles, :xfields, :using => :gin
    add_index :team_roles, :jfields, :using => :gin

    create_table 'team_role_assignments' do |t|
      t.integer  'team_role_id'
      t.integer  'membership_id'
      t.datetime 'started_at'
      t.datetime 'finished_at'
      t.hstore   'xfields',    default: {}
      t.jsonb    'jfields',    default: {}
      t.timestamps
    end
    add_index :team_role_assignments, :team_role_id
    add_index :team_role_assignments, :membership_id
    add_index :team_role_assignments, :started_at
    add_index :team_role_assignments, :finished_at
    add_index :team_role_assignments, :xfields, :using => :gin
    add_index :team_role_assignments, :jfields, :using => :gin
  end
end
