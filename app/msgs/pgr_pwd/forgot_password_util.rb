module PgrPwd::ForgotPasswordUtil

  private

  def gen_sender
    sender = team.memberships.where(rights: 'owner').to_a.first
    if sender.blank?
      sender = team.memberships.where(rights: 'manager').to_a.first
    end
    if sender.blank?
      sender = team.memberships.where(rights: 'active').to_a.first
    end
    sender
  end

  def gen_member
    return nil if email.blank?
    team.memberships.where(user_id: email.user.id).to_a.first
  end

  def member
    @member ||= gen_member
  end

  def user
    @user ||= member.user
  end

  def email
    @email ||= User::Email.where('address ILIKE ?', email_adr).to_a.first
  end

  def long_body
    <<-EOF
      This password reset link expires at #{(Time.now + 30.minutes).strftime("%Y-%m-%d %H:%M")}.
      #{NavBarSvc.team_url(team, env)}/password/reset?token=#{user.forgot_password_token}
    EOF
  end

end
