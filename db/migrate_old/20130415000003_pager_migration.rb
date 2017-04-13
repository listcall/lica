class PagerMigration < ActiveRecord::Migration[5.1]
  def change

    # Pager -> Broadcast -> Target -> Post

    create_table 'pagers' do |t|
      t.integer  'team_id'
      t.timestamps
    end

    create_table 'pager_assignments' do |t|
      t.integer 'sequential_id'                 # sequential ID of a broadcast within a team
      t.integer 'pager_id'
      t.integer 'pager_broadcast_id'
      t.timestamps
    end
    add_index :pager_assignments,  :sequential_id
    add_index :pager_assignments,  :pager_id
    add_index :pager_assignments,  :pager_broadcast_id

    create_table 'pager_broadcasts' do |t|
      t.integer  'sender_id'      # the membership_id of the sender - membership can be associated with any team
      t.integer  'rsvp_id'
      t.boolean  'email',         :default => false
      t.boolean  'phone',         :default => false
      t.boolean  'xmpp',          :default => false
      t.boolean  'app',           :default => false
      t.boolean  'sender_watch',  :default => false
      t.text     'short_body'     # for sms, xmpp, email
      t.text     'long_body'      # for email
      t.integer  'recipient_ids',  array: true, default: []  # a list of target#recipeient ID's (membership_ids)
      t.datetime 'deliver_at'
      t.timestamps
    end
    add_index :pager_broadcasts, :sender_id
    add_index :pager_broadcasts, :rsvp_id

    create_table 'pager_targets' do |t|
      t.integer  'pager_broadcast_id'
      t.integer  'recipient_id'      # the membership_id of the recipient
      t.integer  'period_id'         # operational period
      t.integer  'unread_seconds'
      t.string   'unauth_rsvp_token'
      t.datetime 'unauth_rsvp_expires_at'
      t.string   'rsvp_answer'
      t.string   'unauth_location_token'
      t.datetime 'unauth_location_expires_at'
      t.float    'latitude'
      t.float    'longitude'
      t.hstore   'xfields',         default: {}
      t.boolean  'sender_watch',    default: false
      t.datetime 'sender_last_read_at'
      t.datetime 'recipient_last_read_at'
      t.timestamps
    end
    add_index :pager_targets, :pager_broadcast_id
    add_index :pager_targets, :recipient_id
    add_index :pager_targets, :xfields, :using => :gin

    create_table 'pager_posts' do |t|
      t.integer  'pager_target_id'
      t.integer  'creator_id'        # membership_id of the sender or recipient
      t.text     'short_body'
      t.text     'long_body'
      t.string   'rsvp_answer'
      t.boolean  'bounced',          :default => false
      t.boolean  'ignore_bounce',    :default => false
      t.datetime 'sent_at'
      t.hstore   'xfields',  :default => {}
      t.timestamps
    end
    add_index :pager_posts, :pager_target_id
    add_index :pager_posts, :xfields, :using => :gin

    create_table 'pager_outbounds' do |t|
      t.integer  'pager_post_id'
      t.integer  'recipient_id'
      t.string   'type'     # PagerOutboundEmail, PagerOutboundXmpp, PagerOutboundSms, PagerOutboundApp
      t.integer  'email_id'
      t.integer  'phone_id'
      t.string   'sms_mem_number'   # member sms number
      t.string   'sms_svc_number'   # number used by the SMS service
      t.boolean  'bounced', :default => false
      t.hstore   'xfields', :default => {}
      t.datetime 'read_at'
      t.datetime 'sent_at'
      t.timestamps
    end
    add_index :pager_outbounds, :pager_post_id
    add_index :pager_outbounds, :recipient_id
    add_index :pager_outbounds, :sent_at
    add_index :pager_outbounds, :sms_mem_number
    add_index :pager_outbounds, :sms_svc_number
    add_index :pager_outbounds, :email_id
    add_index :pager_outbounds, :phone_id

    create_table 'pager_rsvp_templates' do |t|
      t.integer  'position'
      t.string   'name'
      t.string   'prompt'
      t.string   'yes_prompt'
      t.string   'no_prompt'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    create_table 'pager_rsvps' do |t|
      t.integer  'message_id'
      t.string   'prompt'
      t.string   'yes_prompt'
      t.string   'no_prompt'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

  end
end

