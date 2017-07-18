class TableRename < ActiveRecord::Migration[5.1]
  def change
    create_table 'cert_exhibits' do |t|
      t.integer  'user_id'
      t.string   'comment'                 # for documentation
      t.string   'link'                    # for documentation
      t.string   'attachment_file_name'    # for documentation
      t.string   'attachment_file_size'    # for documentation
      t.string   'attachment_content_type' # for documentation
      t.string   'attachment_updated_at'   # for documentation
      t.datetime 'expires_at'
      t.datetime 'ninety_day_notice_sent_at'
      t.datetime 'thirty_day_notice_sent_at'
      t.datetime 'expired_notice_sent_at'
      t.hstore   'xfields', default: {}    # for extended fields
      t.timestamps
    end
    add_index :cert_exhibits, :user_id

    create_table 'cert_assignments' do |t|
      t.integer  'membership_id'
      t.integer  'cert_spec_id'
      t.integer  'cert_exhibit_id'
      t.string   'title'
      t.integer  'position'     # scoped by membership and type
      t.string   'status'
      t.string   'ev_type'
      t.integer  'reviewer_id'
      t.string   'reviewed_at'
      t.string   'external_id'           # for sync to 3rd party datastores
      t.hstore   'xfields', default: {}  # for extended fields
      t.datetime 'mc_expires_at'
      t.timestamps
    end
    add_index :cert_assignments, :membership_id
    add_index :cert_assignments, :cert_spec_id
    add_index :cert_assignments, :cert_exhibit_id
    add_index :cert_assignments, :title
    add_index :cert_assignments, :position
    add_index :cert_assignments, :external_id
    add_index :cert_assignments, :mc_expires_at
    add_index :cert_assignments, :ev_type
    add_index :cert_assignments, :xfields, :using => :gin

    create_table 'cert_specs' do |t|
      t.integer 'team_id'
      t.string  'name'
      t.string  'rname'
      t.boolean 'expirable', default: true
      t.boolean 'commentable', default: true
      t.hstore  'xfields', default: {}
      t.text    'ev_types', default: [], array: true
      t.integer 'position'
      t.timestamps
    end
    add_index :cert_specs, :team_id
    add_index :cert_specs, :rname
    add_index :cert_specs, :expirable
    add_index :cert_specs, :commentable
    add_index :cert_specs, :xfields, :using => :gin
    add_index :cert_specs, :ev_types, :using => :gin
    add_index :cert_specs, :position

    create_table :access_roles do |t|
      t.integer 'team_id'
      t.integer 'cert_spec_id'
      t.string  'name'
      t.string  'acronym'
      t.string  'description'
      t.integer 'sort_key'
      t.hstore  'xfields', default: {}
      t.jsonb   'jfields', default: {}
      t.timestamps
    end
    add_index :access_roles, :team_id
    add_index :access_roles, :cert_spec_id
    add_index :access_roles, :acronym
    add_index :access_roles, :sort_key
    add_index :access_roles, :xfields, :using => :gin
    add_index :access_roles, :jfields, :using => :gin

    create_table :access_permissions do |t|
      t.integer 'access_role_id'
      t.string 'label'
    end
  end
end
