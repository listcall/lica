require 'parsers/name_parser'

class User < ActiveRecord::Base

  has_secure_password
  has_attached_file :avatar,
                    :styles => {:medium => '300x300', :roster => '150x150', :thumb => '100x100', :icon => '30x30'},
                    :path   => ':rails_root/public/system/:class/:attachment/:id/:style/:filename',
                    :url    =>                   '/system/:class/:attachment/:id/:style/:filename',
                    :default_url => '/avatar/default_:style.png'

  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/gif image/png image/bmp)

  before_post_process :cleanup_avatar_file_name

  # ----- Associations -----
  has_many :memberships
  has_many :teams, :through => :memberships

  with_options :dependent => :destroy do
    has_many :phones             , -> { order('position ASC') }
    has_many :emails             , -> { order('position ASC') }
    has_many :addresses          , -> { order('position ASC') }
    has_many :other_infos        , -> { order('position ASC') }
    has_many :emergency_contacts , -> { order('position ASC') }
    has_many :user_certs
    has_many :cert_users
  end

  PW_REGEXP = /\A[A-z0-9~!@#$%^&*()_+`={}:";'<>,.?\-\[\]\/]+\z/

  # ----- Validations -----
  validates_presence_of   :first_name,  :last_name, :user_name
  validates_format_of     :title,       :with => /\A[A-Za-z\\.]+\z/, :allow_blank => true
  validates_format_of     :first_name,  :with => /\A[A-Za-z \\-]+\z/
  validates_format_of     :middle_name, :with => /\A[A-Za-z]+\z/,    :allow_blank => true
  validates_format_of     :last_name,   :with => /\A[A-Za-z \\-\\.]+\z/
  validates_format_of     :user_name,   :with => /\A[A-Za-z_0-9\\.\\-]+\z/
  validates_format_of     :password,    :with => PW_REGEXP, unless: ->(u) { u.password.nil? }

  validates :user_name,   uniqueness: { case_sensitive: false }

  # ----- Callbacks -----
  before_validation :set_username,             :on => :create
  before_validation :set_remember_me_token,    :if => :password_digest_changed?
  before_save       :add_default_avatar
  after_save        :touch_teams
  after_touch       :touch_teams

  # ----- Scopes -----
  scope :sans_avatar, -> { where('avatar_file_name IS NULL')     }
  scope :with_avatar, -> { where('avatar_file_name IS NOT NULL') }

  def self.by_phone_num(num)
    joins(:phones).where('user_phones.number = ?', num).to_a.first
  end

  def self.by_email_adr(adr)
    joins(:emails).where('user_emails.address ILIKE ?', adr).to_a.first
  end

  # ----- Local Methods -----

  def add_default_avatar
    return if avatar_file_name.present?
    base = '/tmp/identicons'
    file = "#{base}/default_avatar_#{user_name}.png"
    system "mkdir -p #{base}"
    unless File.exist? file
      RubyIdenticon.create_and_save(user_name, "#{file}", background_color: 0xffffffff)
    end
    image = File.new file
    old_log = Paperclip.options[:log]
    Paperclip.options[:log] = false
    update_attributes(avatar: image)
    Paperclip.options[:log] = old_log
  end

  # ----- Virtual Attributes (Accessors) -----

  def full_name
    lcl_title  = title.blank? ? '' : title + ' '
    lcl_middle = middle_name.blank? ? '' : middle_name + ' '
    lcl_title + first_name + ' ' + lcl_middle + last_name
  end

  def full_name=(input)
    if input.blank?
      self.title = self.first_name = self.middle_name = self.last_name = ''
      return
    end
    parser = Parsers::NameParser.new
    hash   = parser.all.parse(input)
    self.title       = hash[:title].try(:to_s)
    self.first_name  = hash[:first_name].try(:to_s)
    self.middle_name = hash[:middle_name].try(:to_s)
    self.last_name   = hash[:last_name].try(:to_s)
  end

  def cleanup_avatar_file_name
    self.avatar.instance_write(:file_name, "#{self.avatar_file_name.gsub(' ','_')}")
  end

  def touch_teams
    teams.each {|team| team.touch}
  end

  # ----- generate username on create -----

  def set_username
    return unless self.user_name.blank?
    return if self.first_name.blank? || self.last_name.blank?
    ext = ''
    tgt = "#{self.first_name.downcase}#{self.last_name.downcase[0]}"
    while User.find_by_user_name("#{tgt}#{ext}") do
      ext = 1 if ext.blank?
      ext += 1
    end
    self.user_name = "#{tgt}#{ext}"
  end

  # ----- Class Methods -----

  def self.username(name)
    where(user_name: name).to_a.first
  end

  def self.match_full_name(input)
    hash = Parsers::NameParser.new.all.parse(input)
    params = {first_name: hash[:first_name].to_s, last_name: hash[:last_name].to_s}
    pass = rand(36 ** 8).to_s(36)   # generate random password
    pwds = {password: pass, password_confirmation: pass}
    User.where(params).to_a.first || User.create(params.merge(pwds))
  end

  # ----- Token Stuff - Move this to a Service(?) -----

  def reset_forgot_password_token
    Time.zone = 'Pacific Time (US & Canada)'
    self.forgot_password_token      = rand(36 ** 8).to_s(36)
    self.forgot_password_expires_at = Time.now + 30.minutes
    self.save
  end

  def clear_forgot_password_token
    self.forgot_password_token = nil
    self.forgot_password_expires_at = nil
    self.save
  end

  def set_remember_me_token
    self.remember_me_token = rand(36 ** 16).to_s(36)
  end

end

# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  uuid                       :uuid
#  user_name                  :string(255)
#  first_name                 :string(255)
#  middle_name                :string(255)
#  last_name                  :string(255)
#  title                      :string(255)
#  superuser                  :boolean          default("false")
#  developer                  :boolean          default("false")
#  avatar_file_name           :string(255)
#  avatar_content_type        :string(255)
#  avatar_file_size           :integer
#  avatar_updated_at          :integer
#  sign_in_count              :integer          default("0")
#  password_digest            :string(255)
#  remember_me_token          :string(255)
#  forgot_password_token      :string(255)
#  remember_me_created_at     :datetime
#  forgot_password_expires_at :datetime
#  last_sign_in_at            :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#
