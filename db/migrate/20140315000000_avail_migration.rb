class AvailMigration < ActiveRecord::Migration[5.1]

  def change

    create_table 'avail_weeks' do |t|
      t.integer  'team_id'
      t.integer  'membership_id'
      t.integer  'year'
      t.integer  'quarter'
      t.integer  'week'
      t.string   'status'          # [avail, unavail]
      t.string   'comment'
      t.timestamps
    end
    add_index :avail_weeks, :team_id
    add_index :avail_weeks, :membership_id
    add_index :avail_weeks, :status
    add_index :avail_weeks, [:year, :quarter, :week]

    create_table 'avail_days' do |t|
      t.integer  'team_id'
      t.integer  'membership_id'
      t.datetime 'start'
      t.datetime 'finish'
      t.string   'status'          # [avail, unavail]
      t.string   'comment'
      t.timestamps
    end
    add_index :avail_days, :team_id
    add_index :avail_days, :membership_id
    add_index :avail_days, :status
    add_index :avail_days, [:start, :finish]

    # create_table 'service_types' do |t|
    #   t.integer  'team_id'
    #   t.string   'schedule_type'
    #   t.string   'name'
    #   t.string   'description'
    #   t.integer  'position'
    #   t.boolean  'singleton', default: false
    #   t.boolean  'archived' , default: false
    #   t.json     'xdata'    , default: {}
    #   t.hstore   'xfields'  , default: {}
    #   t.timestamps
    # end
    # add_index :service_types, :team_id
    # add_index :service_types, :position
    # add_index :service_types, :schedule_type
    # add_index :service_types, :archived
    # add_index :service_types, :xfields, :using => :gin
    #
    # create_table 'services' do |t|
    #   t.integer  'service_type_id'
    #   t.string   'name'
    #   t.string   'alias'
    #   t.integer  'position'
    #   t.hstore   'xfields', default: {}
    #   t.text     'tags', array: true, default: []
    #   t.boolean  'archived', default: false
    #   t.timestamps
    # end
    # add_index :services,  [:service_type_id, :position, :archived]
    # add_index :services,  :xfields, using: 'gin'
    # add_index :services,  :tags,    using: 'gin'
    #
    # create_table 'service_plans' do |t|
    #   t.integer  'service_id'
    #   t.text     'schedule'       # holds the serialized ice_cube schedule
    #   t.datetime 'start'
    #   t.datetime 'finish'
    #   t.datetime 'schedule_last'  # last day of repeating schedule
    #   t.boolean  'all_day'    , default: false
    #   t.integer  'member_ids' , array:   true   , default: []
    #   t.hstore   'xfields', default: {}
    #   t.timestamps
    # end
    # add_index :service_plans, [:service_id, :start, :finish]
    # add_index :service_plans, [:xfields, :member_ids], :using => :gin
    #
    # create_table 'service_periods' do |t|
    #   t.integer  'service_id'
    #   t.integer  'service_plan_id'
    #   t.string   'service_plan_date' # YYYY-MM-DD - matches plan occurrence
    #   t.integer  'year'              # for weekly_rotating services
    #   t.integer  'quarter'           # for weekly_rotating services
    #   t.integer  'week'              # for weekly_rotating services
    #   t.datetime 'start'
    #   t.datetime 'finish'
    #   t.boolean  'all_day' , default: false
    #   t.hstore   'xfields' , default: {}
    #   t.integer  'service_participants_count', null: false, default: 0
    #   t.timestamps
    # end
    # add_index :service_periods, [:service_id]
    # add_index :service_periods, [:service_plan_id]
    # add_index :service_periods, [:service_plan_date]
    # add_index :service_periods, [:year, :quarter, :week]
    # add_index :service_periods, [:start, :finish]
    # add_index :service_periods, [:xfields], :using => :gin
    #
    # create_table 'service_participants' do |t|
    #   t.integer  'service_period_id'
    #   t.integer  'membership_id'
    #   t.string   'status'
    #   t.datetime 'signed_in_at'
    #   t.datetime 'signed_out_at'
    #   t.hstore   'xfields' , default: {}
    #   t.timestamps
    # end
    # add_index :service_participants, [:service_period_id]
    # add_index :service_participants, [:membership_id]
    # add_index :service_participants, [:status]
    # add_index :service_participants, [:signed_in_at]
    # add_index :service_participants, [:signed_out_at]
    # add_index :service_participants, [:xfields], :using => :gin
    #
    # create_table 'service_partners' do |t|
    #   t.integer 'service_id'
    #   t.integer 'team_id'
    #   t.integer 'position'
    #   t.timestamps
    # end
    # add_index :service_partners, :service_id
    # add_index :service_partners, :team_id
    # add_index :service_partners, :position
    #
    # create_table 'service_msg_recipients' do |t|
    #   t.integer 'membership_id'
    #   t.integer 'service_id'
    #   t.string  'typ'
    #   t.timestamps
    # end
    # add_index :service_msg_recipients, [:service_id, :membership_id]
    # add_index :service_msg_recipients, [:typ]
    #
    # create_table 'svcreps' do |t|
    #   t.string  'name'
    #   t.integer 'team_id'
    #   t.text    'base_template_id'  # <fname> or <id>
    #   t.text    'fork_template_id'  # <id>
    #   t.string  'visibility'
    #   t.integer 'position'
    #   t.boolean 'singleton', default: false
    #   t.hstore  'values'   , default: {}
    #   t.hstore  'xfields'  , default: {}
    #   t.timestamps
    # end
    # add_index :svcreps, :team_id
    # add_index :svcreps, :base_template_id
    # add_index :svcreps, :fork_template_id
    # add_index :svcreps, :position
    # add_index :svcreps, :singleton
    # add_index :svcreps, :values,       using: 'gin'
    # add_index :svcreps, :xfields,      using: 'gin'
    #
    # create_table 'svcrep_services' do |t|
    #   t.integer 'service_id'
    #   t.integer 'svcrep_id'
    #   t.timestamps
    # end
    # add_index :svcrep_services, :service_id
    # add_index :svcrep_services, :svcrep_id
    #
    # create_table 'svcrep_tp_dbs' do |t|  # service reports stored in the DB
    #   t.integer 'owner_team_id'          # team that created the service report
    #   t.text    'name'                   # name of the report
    #   t.text    'text'                   # template text
    #   t.hstore  'xfields', default: {}   # configuration options
    #   t.timestamps
    # end
    # add_index :svcrep_tp_dbs, :owner_team_id
    # add_index :svcrep_tp_dbs, :xfields, using: 'gin'
    #
    # create_table 'svcrep_tp_pickables' do |t|
    #   t.integer 'picker_team_id'    # picker team
    #   t.integer 'svcrep_tp_db_id'   # pickable service report
    #   t.integer 'position'          # so the partner can sort
    #   t.timestamps
    # end
    # add_index :svcrep_tp_pickables, :picker_team_id
    # add_index :svcrep_tp_pickables, :svcrep_tp_db_id
    # add_index :svcrep_tp_pickables, :position

    # add_column :events, :event_periods_count      , :integer, null: false, default: 0
    # add_column :events, :event_participants_count , :integer, null: false, default: 0

  end
end
