class PasswordController < ApplicationController

  before_action :authenticate_manager!, only: [:forgot_for, :sending_for]

  # ----- The User Forgets the Password -----

  # get /password/forgot - collects email address from user
  def forgot
  end

  # post /password/send_email - validates address and sends reset email
  def send_email
    adr = params['email']
    svc = ForgotPasswordSvc.new(current_team, adr, request.env)
    if svc.create
      redirect_to "/password/sending?address=#{adr}"
    else
      flash.now.alert = "Unrecognized email address.  [#{params[:email]}]  Please try again."
      render 'forgot'
    end
  end

  # get /password/sending?address=<adr> - message for the user after the email has been sent
  def sending
    @address = params[:address]
  end

  # ----- The Admin Resets the Password for the User -----

  # get /password/forgot_for?user=<username>
  def forgot_for
    @user = current_team.memberships.by_user_name(params[:user]).try(:to_a).try(:first).try(:user)
    flash.now.alert = "User Name [#{params[:user]}] was not found" if @user.blank?
  end

  # post /password/send_email_for
  def send_email_for
    adr  = params['email']
    user = User.by_email_adr(adr)
    mem  = Membership.find(params['sender_id'])
    svc  = ForgotPasswordForSvc.new(current_team, adr, request.env, mem)
    if svc.create
      redirect_to "/password/sending_for?user=#{user.user_name}"
    else
      flash.now.alert = "Unrecognized email address.  [#{params[:email]}]  Please try again."
      @user = current_team.memberships.by_user_name(params[:user]).try(:to_a).try(:first).try(:user)
      render 'forgot_for'
    end
  end

  # get /password/sending_for?user=<username>
  def sending_for
    @user = current_team.memberships.by_user_name(params[:user]).try(:to_a).try(:first).try(:user)
  end

  # ----- The user clicks on the Reset Link embedded in the Email, and is Logged In -----

  # get /password/reset?token=qwerqwerasdfd - this link is embedded in the email
  # if the token is valid, the user must create a new password
  def reset
    Time.zone = 'Pacific Time (US & Canada)'
    if current_membership.present?
      #redirect_to root_path, :notice => "You are already logged in!"
      #return
      logout
    end
    if params['token'].blank?
      flash.now.alert = 'Unrecognized reset token.  Please try again.'
      render 'forgot'
      return
    end
    @user = User.find_by_forgot_password_token(params['token'])
    if @user && (@user.forgot_password_expires_at > Time.now)
      @user.clear_forgot_password_token
      user_login(@user)
      redirect_to "/users/#{@user.id}/edit"
    else
      flash.now.alert = 'Your password reset token has been used or expired.  Please try again.'
      render 'forgot'
    end
  end

  private

  def logout
    session[:user_id]   = nil
    session[:user_name] = nil
  end

  def user_login(user)
    session[:user_id]   = user.id
    session[:user_name] = user.user_name
    new_user = User.find(user.id)
    new_user.sign_in_count   += 1
    new_user.last_sign_in_at = Time.now
    new_user.password              = ''
    new_user.password_confirmation = ''
    new_user.save
    new_memb = current_membership
    new_memb.sign_in_count = Integer(new_memb.sign_in_count) + 1
    new_memb.last_sign_in_at = Time.now
    new_memb.save
  end

end
