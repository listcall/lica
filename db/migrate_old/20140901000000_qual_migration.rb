class QualMigration < ActiveRecord::Migration[5.1]

  def change

    # ----- qualifications migration -----

    create_table 'user_certs' do |t|
      t.integer  'user_id'
      t.string   'comment'                    # for documentation
      t.string   'link'                       # for documentation
      t.string   'attachment_file_name'       # for documentation
      t.string   'attachment_file_size'       # for documentation
      t.string   'attachment_content_type'    # for documentation
      t.string   'attachment_updated_at'      # for documentation
      t.datetime 'expires_at'
      t.datetime 'ninety_day_notice_sent_at'
      t.datetime 'thirty_day_notice_sent_at'
      t.datetime 'expired_notice_sent_at'
      t.hstore   'xfields', default: {}   # for extended fields
      t.timestamps
    end

    create_table 'membership_certs' do |t|
      t.integer  'membership_id'
      t.integer  'qual_ctype_id'
      t.string   'title'
      t.integer  'position'               # scoped by membership and typ
      t.integer  'user_cert_id'
      t.string   'status'
      t.string   'ev_type'
      t.integer  'reviewer_id'
      t.string   'reviewed_at'
      t.string   'external_id'            # for sync to 3rd party datastores
      t.hstore   'xfields', default: {}   # for extended fields
      t.datetime 'mc_expires_at'
      t.timestamps
    end
    add_index :membership_certs, :membership_id
    add_index :membership_certs, :qual_ctype_id
    add_index :membership_certs, :title
    add_index :membership_certs, :position
    add_index :membership_certs, :user_cert_id
    add_index :membership_certs, :external_id
    add_index :membership_certs, :mc_expires_at
    add_index :membership_certs, :ev_type
    add_index :membership_certs, :xfields, :using => :gin

    create_table 'quals' do |t|
      t.integer 'team_id'
      t.string  'name'
      t.string  'rname'
      t.integer 'position'
      t.hstore  'xfields', default: {}   # for extended fields
      t.timestamps
    end
    add_index :quals, :team_id
    add_index :quals, :rname
    add_index :quals, :position
    add_index :quals, :xfields, :using => :gin

    create_table 'qual_ctypes' do |t|
      t.integer 'team_id'
      t.string  'name'
      t.string  'rname'
      t.boolean 'expirable'   , default: true
      t.boolean 'commentable' , default: true
      t.hstore  'xfields'    , default: {}
      t.text    'ev_types'   , default: [], array: true
      t.integer 'position'
      t.timestamps
    end
    add_index :qual_ctypes, :team_id
    add_index :qual_ctypes, :rname
    add_index :qual_ctypes, :expirable
    add_index :qual_ctypes, :commentable
    add_index :qual_ctypes, :xfields    , :using => :gin
    add_index :qual_ctypes, :ev_types   , :using => :gin
    add_index :qual_ctypes, :position

    create_table 'qual_assignments' do |t|
      t.integer  'qual_id'
      t.integer  'qual_ctype_id'
      t.string   'status'
      t.timestamps
    end
    add_index :qual_assignments, :qual_id
    add_index :qual_assignments, :qual_ctype_id
    add_index :qual_assignments, :status

    create_table 'qual_partnerships' do |t|
      t.integer 'team_id'
      t.integer 'partner_id'
      t.integer 'qual_id'
      t.timestamps
    end
    add_index :qual_partnerships, :team_id
    add_index :qual_partnerships, :partner_id
    add_index :qual_partnerships, :qual_id

  end
end
