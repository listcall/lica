class ForgotPasswordForSvc

  include ForgotPasswordUtil

  attr_reader :team, :email_adr, :env, :sender

  def initialize(team, email_adr, env = nil, sender_param = nil)
    @team      = team
    @email_adr = email_adr
    @env       = env
    @sender    = sender_param || gen_sender
  end

  def create
    return nil if member.blank?
    user.reset_forgot_password_token
    opts = {}
    opts['recipient_ids'] = [member.id]
    opts['sender_id']     = sender.id
    opts['action']        = 'sent page'
    opts['channel']       = 'Autobot'
    opts['email']         = 'on'
    opts['phone']         = 'off'
    opts['short_body']    = "Password Reset (#{user.user_name})"
    opts['long_body']     = long_body
    PagerBroadcastSvc.new(team.pager, opts).create
  end
end