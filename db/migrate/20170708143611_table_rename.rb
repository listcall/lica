class TableRename < ActiveRecord::Migration[5.1]
  def change
    create_table 'cert_proof' do |t|
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
    add_index :cert_proof, :user_id

    create_table 'cert_specs' do |t|
      t.integer 'team_id'
      t.string  'name'
      t.string  'rname'
      t.boolean 'expirable'   , default: true
      t.boolean 'commentable' , default: true
      t.hstore  'xfields' , default: {}
      t.text    'ev_types', default: [], array: true
      t.timestamps
    end
    add_index :cert_specs, :team_id
    add_index :cert_specs, :rname
    add_index :cert_specs, :expirable
    add_index :cert_specs, :commentable
    add_index :cert_specs, :xfields , :using => :gin
    add_index :cert_specs, :ev_types, :using => :gin

    create_table 'cert_prooflinks' do |t|
      t.integer  'membership_id'
      t.integer  'cert_spec_id'
      t.integer  'cert_proof_id'
      t.string   'title'
      t.integer  'position'              # scoped by membership and spec
      t.string   'status'
      t.string   'ev_type'
      t.integer  'reviewer_id'
      t.string   'reviewed_at'
      t.string   'external_id'           # for sync to 3rd party datastores
      t.hstore   'xfields', default: {}  # for extended fields
      t.datetime 'mc_expires_at'
      t.timestamps
    end
    add_index :cert_prooflinks, :membership_id
    add_index :cert_prooflinks, :cert_spec_id
    add_index :cert_prooflinks, :cert_proof_id
    add_index :cert_prooflinks, :title
    add_index :cert_prooflinks, :position
    add_index :cert_prooflinks, :external_id
    add_index :cert_prooflinks, :mc_expires_at
    add_index :cert_prooflinks, :ev_type
    add_index :cert_prooflinks, :xfields, :using => :gin

    create_table 'cert_groups' do |t|
      t.integer 'team_id'
      t.integer 'position'
      t.string  'name'
      t.hstore  'xfields', default: {}
      t.jsonb   'jfields', default: {}
      t.timestamps
    end
    add_index :cert_groups, :position
    add_index :cert_groups, :xfields , :using => :gin
    add_index :cert_groups, :jfields , :using => :gin
    add_index :cert_groups, :team_id

    create_table 'cert_grouplinks' do |t|
      t.integer 'cert_spec_id'
      t.integer 'cert_group_id'
      t.integer 'position'                      # scoped by cert_group and cert_spec
    end
    add_index :cert_grouplinks, :cert_spec_id
    add_index :cert_grouplinks, :cert_group_id
    add_index :cert_grouplinks, :position

    create_table :cert_permissions do |t|
      t.integer 'cert_spec_id'
      t.string  'label'
    end
    add_index :cert_permissions, :cert_spec_id
  end
end
