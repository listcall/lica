class EventMigration < ActiveRecord::Migration[5.1]
  def change

    create_table  :events do |t|
      t.string    :event_ref        # YYMMDDTN
      t.integer   :team_id
      t.integer   :parent_id
      t.string    :typ
      t.string    :title
      t.string    :leaders
      t.text      :description
      t.string    :location_name
      t.string    :location_address
      t.decimal   :lat, :precision => 7, :scale => 4
      t.decimal   :lon, :precision => 7, :scale => 4
      t.datetime  :start
      t.datetime  :finish
      t.boolean   :all_day,   :default => true
      t.boolean   :published, :default => false
      t.text      :tags,      :array   => true, :default => []
      t.hstore    :xfields,   :default => {}
      t.integer   :event_periods_count     , default: 0, null: false   # hackery
      t.integer   :event_participants_count, default: 0, null: false   # hackery
      t.string    :external_id
      t.string    :signature
      t.string    :ancestry
      t.timestamps
    end
    add_index :events, :event_ref
    add_index :events, :team_id
    add_index :events, :typ
    add_index :events, :title
    add_index :events, :start
    add_index :events, :external_id
    add_index :events, :signature
    add_index :events, :ancestry
    add_index :events, :xfields, :using => :gin
    add_index :events, :tags   , :using => :gin

    create_table :event_periods do |t|
      t.integer   :event_id
      t.integer   :parent_id
      t.integer   :position
      t.string    :location
      t.datetime  :start
      t.datetime  :finish
      t.string    :ancestry
      t.string    :external_id
      t.timestamps
    end
    add_index :event_periods, :event_id
    add_index :event_periods, :position
    add_index :event_periods, :ancestry
    add_index :event_periods, :external_id

    create_table :event_participants do |t|
      t.integer   :membership_id
      t.integer   :event_period_id
      t.string    :role
      t.string    :comment
      t.timestamp :departed_at
      t.timestamp :returned_at
      t.timestamp :signed_in_at
      t.timestamp :signed_out_at
      t.timestamps
    end
    add_index :event_participants, :membership_id
    add_index :event_participants, :event_period_id
    add_index :event_participants, :role

    create_table :event_reports do |t|
      t.string   :typ
      t.integer  :event_period_id
      t.string   :title
      t.integer  :position
      t.hstore   :data       , :default => {}
      t.boolean  :published  , :default => false
      t.timestamps
    end
    add_index :event_reports, :event_period_id

    # ----- event reference -----

    #create_table "event_links" do |t|
    #  t.integer  "event_id"
    #  t.integer  "data_link_id"
    #  t.text     "keyval"
    #  t.timestamps
    #end
    #
    #create_table "event_photos" do |t|
    #  t.integer  "event_id"
    #  t.integer  "data_photo_id"
    #  t.text     "keyval"
    #  t.timestamps
    #end
    #
    #create_table "event_files" do |t|
    #  t.integer  "event_id"
    #  t.integer  "data_file_id"
    #  t.text     "keyval"
    #  t.datetime "created_at",   :null => false
    #  t.datetime "updated_at",   :null => false
    #end

  end

end
