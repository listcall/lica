class PositionsMigration < ActiveRecord::Migration

  def change
    create_table 'positions' do |t|
      t.integer 'team_id'
      t.integer 'team_role_id'
      t.integer 'sort_key'
      t.hstore  'xfields', default: {}
      t.jsonb   'jfields', default: {}
      t.timestamps
    end
    add_index :positions, :team_id
    add_index :positions, :team_role_id
    add_index :positions, :xfields, :using => :gin
    add_index :positions, :jfields, :using => :gin

    create_table 'position_periods' do |t|
      t.integer 'position_id'
      t.integer 'assignee_id'      # a membership id
      t.integer 'year'
      t.integer 'quarter'
      t.integer 'week'
      t.jsonb   'jfields', default: {}
      t.hstore  'xfields', default: {}
      t.timestamps
    end
    add_index :position_periods, :position_id
    add_index :position_periods, :assignee_id
    add_index :position_periods, :year
    add_index :position_periods, :quarter
    add_index :position_periods, :week
    add_index :position_periods, :xfields, :using => :gin
    add_index :position_periods, :jfields, :using => :gin

    create_table 'position_bookings' do |t|
      t.integer  'position_period_id'
      t.integer  'membership_id'      # the 'bookee'
      t.hstore   'xfields', default: {}
      t.jsonb    'jfields', default: {}
      t.timestamps
    end
    add_index :position_bookings, :position_period_id
    add_index :position_bookings, :membership_id
    add_index :position_bookings, :jfields, :using => :gin
    add_index :position_bookings, :xfields, :using => :gin

    create_table 'position_partners' do |t|
      t.integer  'position_id'
      t.integer  'partner_id'                 # the team_id of the partner team
      t.integer  'sort_key'
      t.hstore   'xfields', default: {}
      t.jsonb    'jfields', default: {}
      t.timestamps
    end
    add_index :position_partners, :position_id
    add_index :position_partners, :partner_id
    add_index :position_partners, :jfields, :using => :gin
    add_index :position_partners, :xfields, :using => :gin

    # create_table 'svcs' do |t|
    #   t.integer  'team_id'
    #   t.string   'name'
    #   t.string   'acronym'
    #   t.integer  'sort_key'
    #   t.hstore   'xfields', default: {}
    #   t.jsonb    'jfields', default: {}
    #   t.text     'tags', array: true, default: []
    #   t.boolean  'archived', default: false
    #   t.timestamps
    # end
    # add_index :svcs,  :team_id
    # add_index :svcs,  :acronym
    # add_index :svcs,  :archived
    # add_index :svcs,  :xfields, using: 'gin'
    # add_index :svcs,  :jfields, using: 'gin'
    # add_index :svcs,  :tags,    using: 'gin'

    # create_table 'svc_plans' do |t|
    #   t.integer  'svc_id'
    #   t.text     'schedule'       # holds the serialized ice_cube schedule
    #   t.datetime 'start'
    #   t.datetime 'finish'
    #   t.datetime 'schedule_last'  # last day of repeating schedule
    #   t.boolean  'all_day'    , default: false
    #   t.integer  'member_ids' , array:   true   , default: []
    #   t.hstore   'xfields', default: {}
    #   t.jsonb    'jfields', default: {}
    #   t.timestamps
    # end
    # add_index :svc_plans, :svc_id
    # add_index :svc_plans, :start
    # add_index :svc_plans, :finish
    # add_index :svc_plans, :member_ids
    # add_index :svc_plans, :xfields,      :using => :gin
    # add_index :svc_plans, :jfields,      :using => :gin

    # create_table 'svc_periods' do |t|
    #   t.integer  'svc_id'
    #   t.integer  'svc_plan_id'
    #   t.string   'svc_plan_date'    # YYYY-MM-DD - matches plan occurrence
    #   t.datetime 'start'
    #   t.datetime 'finish'
    #   t.boolean  'all_day' , default: false
    #   t.hstore   'xfields' , default: {}
    #   t.jsonb    'jfields' , default: {}
    #   t.integer  'svc_participants_count', null: false, default: 0
    #   t.timestamps
    # end
    # add_index :svc_periods, :svc_id
    # add_index :svc_periods, :svc_plan_id
    # add_index :svc_periods, :svc_plan_date
    # add_index :svc_periods, :start
    # add_index :svc_periods, :finish
    # add_index :svc_periods, :xfields, :using => :gin
    # add_index :svc_periods, :jfields, :using => :gin

    # create_table 'svc_participants' do |t|
    #   t.integer  'svc_period_id'
    #   t.integer  'membership_id'
    #   t.string   'status'
    #   t.datetime 'signed_in_at'
    #   t.datetime 'signed_out_at'
    #   t.hstore   'xfields' , default: {}
    #   t.jsonb    'jfields' , default: {}
    #   t.timestamps
    # end
    # add_index :svc_participants, :svc_period_id
    # add_index :svc_participants, :membership_id
    # add_index :svc_participants, :status
    # add_index :svc_participants, :signed_in_at
    # add_index :svc_participants, :signed_out_at
    # add_index :svc_participants, :xfields, :using => :gin
    # add_index :svc_participants, :jfields, :using => :gin

    # create_table 'svc_partners' do |t|
    #   t.integer  'svc_id'
    #   t.integer  'team_id'
    #   t.integer  'sort_key'
    #   t.hstore   'xfields' , default: {}
    #   t.jsonb    'jfields' , default: {}
    #   t.timestamps
    # end
    # add_index :svc_partners, :svc_id
    # add_index :svc_partners, :team_id
    # add_index :svc_partners, :sort_key
    # add_index :svc_partners, :xfields, :using => :gin
    # add_index :svc_partners, :jfields, :using => :gin

    # create_table 'svc_msg_recipients' do |t|
    #   t.integer  'membership_id'
    #   t.integer  'svc_id'
    #   t.string   'typ'
    #   t.hstore   'xfields' , default: {}
    #   t.jsonb    'jfields' , default: {}
    #   t.timestamps
    # end
    # add_index :svc_msg_recipients, :svc_id
    # add_index :svc_msg_recipients, :membership_id
    # add_index :svc_msg_recipients, :typ
    # add_index :svc_msg_recipients, :xfields, :using => :gin
    # add_index :svc_msg_recipients, :jfields, :using => :gin

    # create_table 'reps' do |t|
    #   t.string   'type'
    #   t.integer  'team_id'
    #   t.string   'name'
    #   t.text     'base_template_id'  # <fname> or <id>
    #   t.text     'fork_template_id'  # <id>
    #   t.string   'visibility'
    #   t.integer  'sort_key'
    #   t.hstore   'values'     , default: {}
    #   t.hstore   'xfields'    , default: {}
    #   t.jsonb    'jfields'    , default: {}
    #   t.timestamps
    # end
    # add_index :reps, :type
    # add_index :reps, :team_id
    # add_index :reps, :base_template_id
    # add_index :reps, :fork_template_id
    # add_index :reps, :values,       using: 'gin'
    # add_index :reps, :xfields,      using: 'gin'
    # add_index :reps, :jfields,      using: 'gin'

    # templates can come from the filesystem (fs) or the database (db)
    # fs is for in-house developed templates
    # db is for user forks and customizations
    # create_table 'rep_template_dbs' do |t|  # templates stored in the DB
    #   t.integer 'owner_team_id'                # team that created the template
    #   t.text    'name'                         # name of the template
    #   t.text    'text'                         # template text
    #   t.hstore  'xfields', default: {}         # configuration options
    #   t.jsonb   'jfields', default: {}
    #   t.timestamps
    # end
    # add_index :rep_template_dbs, :owner_team_id
    # add_index :rep_template_dbs, :xfields, using: 'gin'
    # add_index :rep_template_dbs, :jfields, using: 'gin'

    # for sharing rep templates with partner teams
    # create_table 'rep_template_pickables' do |t|
    #   t.integer  'picker_team_id'         # picker team
    #   t.integer  'rep_template_db_id'     # pickable template
    #   t.integer  'sort_key'               # so the partner can sort
    #   t.hstore   'xfields'    , default: {}
    #   t.jsonb    'jfields'    , default: {}
    #   t.timestamps
    # end
    # add_index :rep_template_pickables, :picker_team_id
    # add_index :rep_template_pickables, :rep_template_db_id
    # add_index :rep_template_pickables, :sort_key
    # add_index :rep_template_pickables, :xfields, using: 'gin'
    # add_index :rep_template_pickables, :jfields, using: 'gin'

    # for testing macros...
    # create_table 'app_ext_tsts' do |t|
    #   t.string  'title'
    #   t.json    '_config', default: {}
    #   t.hstore  'xfields', default: {}
    #   t.json    'jfields', default: {}
    #   t.jsonb   'jdatab',  default: {}
    #   t.integer 'iarr1',    array: true, default: []
    #   t.integer 'iarr2',    array: true, default: []
    #   t.string  'sarr1',    array: true, default: []
    #   t.string  'sarr2',    array: true, default: []
    #   t.timestamps
    # end
    # add_index :app_ext_tsts, :xfields, :using => :gin
    # add_index :app_ext_tsts, :jdatab , :using => :gin
  end
end
