class MemCertForm
  include ActiveModel::Model

  # ----- attributes -----
  MEM_KEYS = %i(id title membership_id qual_ctype_id position ev_type)
  USR_KEYS = %i(comment link attachment expires_at)
  ALT_KEYS = %i(del_attachment)

  attr_accessor *MEM_KEYS
  attr_accessor *USR_KEYS
  attr_accessor *ALT_KEYS

  # ----- validations -----
  DATE_REGEX = /\A20[01][0-9]\-[01][0-9]\-[0123][0-9]\Z/

  validates_presence_of :title, :membership_id, :qual_ctype_id
  validates_format_of   :expires_at  , with: DATE_REGEX , allow_blank: true

  validates :title   , length: {in: 2..30    }
  validates :comment , length: {maximum: 60  }
  validates :link    , length: {maximum: 100 }

  validate :verify_attachment_format
  validate :verify_expires_at

  def verify_attachment_format
    return if attachment.blank?
    formats = %w(jpeg jpg gif png pdf msword)
    unless formats.include?(attachment.content_type.split('/').last.downcase)
      errors.add :attachment, "valid formats: #{formats.join(', ')}"
    end
  end

  def verify_expires_at
    return if mem_cert.blank?
    return unless mem_cert.ctype.try(:expirable)
    return unless expires_at.blank?
    errors.add :expire_date, 'must be present'
  end

  # ----- active model support -----
  def persisted?
    false
  end

  # ----- instance methods -----

  def generate
    return false unless valid?
    create_usr_cert
    create_mem_cert
    if usr_cert.valid? && mem_cert.valid? && valid?
      self.id = mem_cert.id
      self
    else
      mem_cert.try(:destroy)
      mem_cert.try(:destroy)
      usr_cert.try(:destroy)
      false
    end
  end

  def update
    return false unless valid?
    update_usr_cert
    update_mem_cert
    return false unless usr_cert.valid? && mem_cert.valid?
    self
  end

  def mem_cert
    return nil if @mem_cert.nil? && id.nil?
    @mem_cert ||= MembershipCert.find(id)
  end

  def usr_cert
    @usr_cert ||= mem_cert.try(:user_cert)
  end

  def qual_ctype_id
    @qual_ctype_id ||= mem_cert.try(:qual_ctype_id)
  end

  def membership_id
    @membership_id ||= mem_cert.try(:membership_id)
  end

  def title
    @title ||= mem_cert.try(:title)
  end

  def comment
    @comment ||= usr_cert.try(:comment)
  end

  def expires_at
    @expires_at ||= usr_cert.try(:expires_at)
  end

  def title_select_method
    ctype.title_select_method
  end

  def title_fixed_options
    ctype.title_fixed_options
  end

  # ----- predicates -----

  def has_expires?
    ctype.has_expires?
  end

  def has_comment?
    ctype.has_comment?
  end

  def has_link?
    ctype.has_link?
  end

  def has_attachment?
    ctype.has_attachment?
  end

  def expire_date
    expires_at.try(:strftime, '%Y-%m-%d')
  end

  def expire_date=(date)
    @expires_at = date
  end

  private

  def create_mem_cert
    @usr_cert ||= create_usr_cert
    @mem_cert = MembershipCert.create(mem_attrs.merge({user_cert_id: @usr_cert.id}))
  end

  def create_usr_cert
    @usr_cert = UserCert.create(usr_attrs.merge({user_id: user.id}))
  end

  def update_usr_cert
    atts = usr_attrs
    atts.delete(:attachment) if attachment.blank? && del_attachment.blank?
    atts.delete(:comment)    if comment.blank?
    atts.delete(:link)       if link.blank?
    usr_cert.update_attributes(atts)
  end

  def update_mem_cert
    mem_cert.update_attributes(mem_attrs)
  end

  def member
    @member ||= Membership.find(membership_id)
  end

  def user
    @user ||= member.user
  end

  def ctype
    @ctype ||= QualCtype.find(qual_ctype_id)
  end

  def mem_attrs
    MEM_KEYS.reduce({}) do |acc, val|
      acc[val] = self.send val
      acc
    end
  end

  def usr_attrs
    USR_KEYS.reduce({}) do |acc, val|
      acc[val] = self.send val
      acc
    end
  end

  def assign_attributes(values)
    values.each {|key,val| send("#{key}=", val)}
    self
  end

  def normalize(params)
    params.reduce({}) {|acc, (key, val)| acc[key.to_sym] = val; acc}
  end

end