class RecruitForm

  include ActiveModel::Model

  # ----- attributes -----

  KEYS = %i(team_id title first_name middle_name last_name rank phone_typ phone_num email_typ email_adr)

  attr_accessor *KEYS
  attr_reader   :user, :email, :phone, :member

  # ----- validations -----

  PHONE_REGEX = /\A\d\d\d-\d\d\d-\d\d\d\d\z/
  EMAIL_REGEX = /.+@.+\..+/
  NAME_REGEX  = /\A[A-Za-z \-\.\']+\z/

  validates :team_id     , presence: true
  validates :first_name  , presence: true
  validates :last_name   , presence: true

  validates_format_of :first_name, with: NAME_REGEX
  validates_format_of :last_name,  with: NAME_REGEX
  validates_format_of :phone_num,  with: PHONE_REGEX, allow_blank: true
  validates_format_of :email_adr,  with: EMAIL_REGEX, allow_blank: true

  validate :phone_or_email

  def phone_or_email
    return unless phone_num.blank? && email_adr.blank?
    errors.add :phone_num, 'required'
    errors.add :email_adr, 'required'
  end

  # ----- instance methods -----

  def save
    create_or_find_user
    create_or_find_email
    create_or_find_phone
    create_or_find_member
  end

  def form_rank
    self.rank || default_rank
  end

  def form_rank=(val)
    self.rank = val
  end

  # ----- active model support -----

  def persisted?; false; end

  def self.model_name; ActiveModel::Name.new(self, nil, 'Membership'); end

  private

  def team
    @team ||= Team.find(team_id)
  end

  def create_or_find_user
    @user = User.by_phone_num(phone_num) || User.by_email_adr(email_adr) || User.create(user_params)
  end

  def create_or_find_phone
    args1 = {user_id: user.id, number: phone_num}
    args2 = args1.merge({typ: phone_typ})
    @phone ||= User::Phone.where(args1).to_a.first || User::Phone.create(args2)
  end

  def create_or_find_email
    args = {user_id: user.id, address: email_adr, typ: email_typ}
    @email ||= user.emails.where('address ILIKE ?', email_adr).to_a.first || User::Email.create(args)
  end

  def create_or_find_member
    @member ||= Membership.where(team_id: team.id, user_id: user.id).to_a.first || create_member
  end

  def normalize(params)
    params.reduce({}) {|acc, (key, val)| acc[key.to_sym] = val; acc}
  end

  def create_member
    args = {user_id: user.id, team_id: team.id, rank: form_rank}
    Membership.create(args)
  end

  def user_params
    pwd = rand(36 ** 8).to_s(36)
    {first_name: first_name, last_name: last_name, password: pwd, password_confirmation: pwd}
  end

  def default_rank
    # rights = team.member_ranks.to_data.values.select { |x| ! %w(alum inactive).include?(x[:rights]) }
    # rights.reverse.first[:label]
    team.ranks.first.label
  end

end