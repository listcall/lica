class BaseMigration < ActiveRecord::Migration[5.1]
  def change

    enable_extension :hstore

    # ----- organization -----
    create_table 'orgs' do |t|
      t.uuid    'uuid'
      t.string  'typ'             # [enterprise | hosting | system]
      t.string  'name'            # account name
      t.string  'domain'          # account domain
      t.integer 'org_team_id'     # every org has one 'org team'
      # every system must have a single fallback account
      # fallback accounts are used when someone renders an unknown domain
      # in this situation, they are directed to Account.fallback.org_team#domain_not_found
      t.boolean 'fallback', :default => false
      t.timestamps
    end
    add_index :orgs, :org_team_id

    # ----- users -----

    create_table 'users' do |t|\
      t.uuid     'uuid'
      t.string   'user_name'
      t.string   'first_name'
      t.string   'middle_name'
      t.string   'last_name'
      t.string   'title'
      t.boolean  'superuser',                  :default => false
      t.boolean  'developer',                  :default => false
      t.string   'avatar_file_name'
      t.string   'avatar_content_type'
      t.integer  'avatar_file_size'
      t.integer  'avatar_updated_at'
      t.integer  'sign_in_count',              :default => 0
      t.string   'password_digest'
      t.string   'remember_me_token'
      t.string   'forgot_password_token'
      t.datetime 'remember_me_created_at'
      t.datetime 'forgot_password_expires_at'
      t.datetime 'last_sign_in_at'
      t.timestamps
    end

    create_table 'user_addresses' do |t|
      t.integer  'user_id'
      t.string   'typ'
      t.string   'address1',   :default => ''
      t.string   'address2',   :default => ''
      t.string   'city',       :default => ''
      t.string   'state',      :default => ''
      t.string   'zip',        :default => ''
      t.boolean  'visible',    :default => true
      t.integer  'position'
      t.timestamps
    end

    create_table 'user_emails' do |t|
      t.integer  'user_id'
      t.string   'typ'
      t.string   'address'
      t.boolean  'pagable'
      t.integer  'position'
      t.boolean  'visible',    :default => true
      t.timestamps
    end

    create_table 'user_phones' do |t|
      t.integer  'user_id'
      t.string   'typ'
      t.string   'number'
      t.boolean  'pagable'
      t.integer  'position'
      t.boolean  'visible',    :default => true
      t.timestamps
    end

    create_table 'user_emergency_contacts' do |t|
      t.integer  'user_id'
      t.string   'name'
      t.string   'kinship'           # husband | wife | roommante | father | etc.
      t.string   'phone_number'      # nnn-nnn-nnnn
      t.string   'phone_type'        # Mobile, Home, Work, Other
      t.integer  'position'          # for sorting
      t.boolean  'visible',    :default => true
      t.timestamps
    end

    create_table 'user_other_infos' do |t|
      t.integer  'user_id'
      t.string   'label'
      t.string   'value'
      t.integer  'position'
      t.timestamps
    end

    create_table 'user_browser_profiles' do |t|
      t.integer  'user_id'
      t.string   'ip'
      t.string   'browser_type'
      t.string   'browser_version'
      t.text     'user_agent'
      t.string   'ostype'
      t.boolean  'javascript'
      t.boolean  'cookies'
      t.integer  'screen_height'
      t.integer  'screen_width'
      t.timestamps
    end

    # ----- member data -----

    create_table 'memberships' do |t|
      t.uuid     'uuid'
      # t.json     '_config'
      t.string   'rights'     # cached rights value (owner,manager,active,reserve,guest,inactive) for fast SQL queries
      t.integer  'user_id'    # userID
      t.integer  'team_id'    # teamID
      t.string   'rank'       # TeamRankID (must be one of @team.member_ranks.keys)
      t.text     'roles',    default: [], array: true  # TeamRoleIDs (must match @team.member_roles.keys)
      # t.hstore   'settings', default: {}               # storage for member settings
      t.hstore   'xfields',  default: {}               # storage for extended fields
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :team_id
    add_index :memberships, :rights
    add_index :memberships, :xfields, :using => :gin
    add_index :memberships, :roles,   :using => :gin

    # ----- team data -----

    create_table 'teams' do |t|
      t.uuid        'uuid'
      t.json        '_config', default: {}
      t.integer     'org_id'        # team organization
      t.string      'typ'           # [account | field]
      t.string      'acronym'       # short team acronym (like 'BAMRU')
      t.string      'name'          # full team name (like 'Bay Area Mountain Rescue Unit')
      t.string      'subdomain'     # <subdomain>.<account_domain>
      t.string      'altdomain'     # alternative FQDN
      t.string      'logo_text'     # goes on nav bar
      t.string      'icon_file_name'     # paperclip attachment
      t.string      'icon_content_type'  # paperclip attachment      t.string   "avatar_file_name"
      t.integer     'icon_file_size'
      t.integer     'icon_updated_at'
      t.text        'enc_pw_hash'                              # password hash for unlocking encrypted fields
      t.hstore      'docfields'   , default: {}
      t.text        'enc_members' , default: [], array: true   # array of members who can view encrypted fields
      t.boolean     'published'   , default: false
      t.timestamps
    end
    add_index :teams, :org_id

    # ----- team partnerships -----
    # inspired by http://francik.name/rails2010/week10.html

    create_table 'team_partnerships' do |t|
      t.integer       'team_id'
      t.integer       'partner_id'
      t.string        'status'
      t.timestamps
    end
    add_index :team_partnerships, :team_id
    add_index :team_partnerships, :partner_id
    add_index :team_partnerships, :status

    # ----- TBD resources -----

    #create_table "team_files" do |t|
    #  t.integer  "team_id"
    #  t.integer  "membership_id"
    #  t.string   "team_file_file_extension"
    #  t.string   "team_file_file_name"
    #  t.string   "team_file_file_size"
    #  t.string   "team_file_content_type"
    #  t.string   "team_file_updated_at"
    #  t.boolean  "published",           :default => false
    #  t.integer  "download_count",      :default => 0
    #  t.string   "caption"
    #  t.timestamps
    #end

    #create_table "team_links" do |t|
    #  t.integer  "team_id"
    #  t.integer  "membership_id"
    #  t.string   "site_url"
    #  t.string   "caption"
    #  t.boolean  "published",                :default => false
    #  t.string   "link_backup_file_name"
    #  t.string   "link_backup_content_type"
    #  t.integer  "link_backup_file_size"
    #  t.integer  "link_backup_updated_at"
    #  t.integer  "position"
    #  t.datetime "created_at",                                  :null => false
    #  t.datetime "updated_at",                                  :null => false
    #end
    #
    #create_table "team_photos" do |t|
    #  t.integer  "membership_id"
    #  t.string   "caption"
    #  t.string   "image_file_name"
    #  t.string   "image_content_type"
    #  t.integer  "image_file_size"
    #  t.integer  "image_updated_at"
    #  t.integer  "position"
    #  t.boolean  "published",          :default => false
    #  t.datetime "created_at",                            :null => false
    #  t.datetime "updated_at",                            :null => false
    #end

  end
end

