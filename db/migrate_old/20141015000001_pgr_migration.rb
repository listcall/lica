class PgrMigration < ActiveRecord::Migration[5.1]
  def change

    # Pager -> Broadcast -> Thread -> Post

    create_table 'pgrs' do |t|
      t.integer  'team_id'
      t.timestamps
    end

    create_table 'pgr_assignments' do |t|
      t.integer 'sequential_id'                 # sequential ID of a broadcast within a team
      t.integer 'pgr_id'
      t.integer 'pgr_broadcast_id'
      t.timestamps
    end
    add_index :pgr_assignments,  :sequential_id
    add_index :pgr_assignments,  :pgr_id
    add_index :pgr_assignments,  :pgr_broadcast_id

    create_table 'pgr_broadcasts' do |t|
      t.integer  'sender_id'       # the membership_id of the sender - membership can be associated with any team
      t.text     'short_body'      # for sms, xmpp, email
      t.text     'long_body'       # for email
      t.datetime 'deliver_at'      # for timed deliveries
      t.integer  'recipient_ids' , array: true, default: []  # list of membership_ids
      t.hstore   'xfields'       , default: {}
      t.jsonb    'jfields'       , default: {}
      t.timestamps
    end
    add_index :pgr_broadcasts, :sender_id
    add_index :pgr_broadcasts, :xfields , :using => :gin
    add_index :pgr_broadcasts, :jfields , :using => :gin

    create_table 'pgr_dialogs' do |t|
      t.integer  'pgr_broadcast_id'
      t.integer  'recipient_id'               # membership_id of the recipient
      t.datetime 'recipient_read_at'          # time the recipient read msg
      t.string   'unauth_action_token'
      t.datetime 'unauth_action_expires_at'
      t.string   'action_response'
      t.hstore   'xfields',         default: {}
      t.jsonb    'jfields',         default: {}
      t.timestamps
    end
    add_index :pgr_dialogs, :pgr_broadcast_id
    add_index :pgr_dialogs, :recipient_id
    add_index :pgr_dialogs, :action_response
    add_index :pgr_dialogs, :xfields     , :using => :gin
    add_index :pgr_dialogs, :jfields     , :using => :gin

    create_table 'pgr_posts' do |t|
      t.string   'type'                  # StiAction, StiMsg
      t.integer  'pgr_dialog_id'
      t.integer  'author_id'             # member who created the post
      t.integer  'target_id'             # member who recieves the post
      t.text     'short_body'
      t.text     'long_body'
      t.string   'action_response'
      t.boolean  'bounced',          :default => false
      t.boolean  'ignore_bounce',    :default => false
      t.datetime 'sent_at'
      t.datetime 'read_at'
      t.hstore   'xfields',  :default => {}
      t.jsonb    'jfields',  :default => {}
      t.timestamps
    end
    add_index :pgr_posts, :type
    add_index :pgr_posts, :pgr_dialog_id
    add_index :pgr_posts, :author_id
    add_index :pgr_posts, :target_id
    add_index :pgr_posts, :action_response
    add_index :pgr_posts, :xfields, :using => :gin
    add_index :pgr_posts, :jfields, :using => :gin

    create_table 'pgr_outbounds' do |t|
      t.string   'type'             # StiEmail, StiXmpp, StiPhone, StiAlarm
      t.integer  'pgr_post_id'
      t.integer  'target_id'        # a Membership id
      t.integer  'device_id'        # polymorphic / UserPhone, UserEmail
      t.string   'device_type'      # polymorphic class
      t.string   'target_channel'   # poly_type => email, phone
      t.string   'origin_address'   # for SMS origin number
      t.string   'target_address'   # poly_id   => phone num, email adr, etc.
      t.boolean  'bounced', :default => false
      t.hstore   'xfields', :default => {}
      t.datetime 'sent_at'
      t.datetime 'read_at'
      t.timestamps
    end
    add_index :pgr_outbounds, :type
    add_index :pgr_outbounds, :pgr_post_id
    add_index :pgr_outbounds, :target_id
    add_index :pgr_outbounds, :device_id
    add_index :pgr_outbounds, :device_type
    add_index :pgr_outbounds, :target_channel
    add_index :pgr_outbounds, :origin_address
    add_index :pgr_outbounds, :target_address
    add_index :pgr_outbounds, :bounced
    add_index :pgr_outbounds, :sent_at
    add_index :pgr_outbounds, :read_at
    add_index :pgr_outbounds, :xfields, :using => :gin

    create_table 'pgr_actions' do |t|
      t.integer  'pgr_broadcast_id'
      t.string   'type'
      t.hstore   'xfields', :default => {}
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
    add_index :pgr_actions, :type
    add_index :pgr_actions, :pgr_broadcast_id
    add_index :pgr_actions, :xfields, :using => :gin

    create_table 'pgr_templates' do |t|
      t.integer  'team_id'
      t.integer  'position'
      t.string   'name'
      t.string   'description'
      t.hstore   'xfields', :default => {}
      t.timestamps
    end
    add_index :pgr_templates, :team_id
    add_index :pgr_templates, :xfields, :using => :gin

    create_table 'inbounds' do |t|
      t.integer 'team_id'
      t.integer 'pgr_dialog_id'
      t.string  'type'        # email / phone / xmpp
      t.string  'proxy'       # letter_opener / mandrill / plivo
      t.string  'subject'
      t.string  'fm'
      t.string  'to'     , :array   => true, default: []
      t.hstore  'headers', :default => {}
      t.text    'text'
      t.string  'destination_type'   # pgr / forum / password
      t.integer 'destination_id'     # id of pgr, forum, etc.
      t.hstore  'xfields', :default => {}   # subject, body text, etc.
      t.timestamps
    end
    add_index :inbounds, :team_id
    add_index :inbounds, :pgr_dialog_id
    add_index :inbounds, :type
    add_index :inbounds, :proxy
    add_index :inbounds, :subject
    add_index :inbounds, :fm
    add_index :inbounds, :to     , :using => :gin
    add_index :inbounds, :headers, :using => :gin
    add_index :inbounds, :text
    add_index :inbounds, :xfields, :using => :gin

    change_table 'memberships' do |t|
      t.integer 'rights_score', default: 0
      t.integer 'rank_score'  , default: 100
      t.integer 'role_score'  , default: 0
    end
    add_index :memberships, :rights_score
    add_index :memberships, :rank_score
    add_index :memberships, :role_score
  end
end

