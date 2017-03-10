class SessionsController < ApplicationController

  skip_around_action :scope_current_team
  # ActionController::Parameters.permit_all_parameters = true

  def new
    @user = User.find_by_remember_me_token(cookies[:remember_me_token])
    if @user.nil?
      @user = User.new
    else
      session[:user_id]   = @user.id
      session[:user_name] = @user.full_name
      redirect_to (session[:tgt_path] || root_path), :notice => "Welcome back #{@user.first_name}"
    end
  end

  def create
    opts = params["user"]
    @user = UserFinderSvc.by_username(opts[:user_name])
    if @user && @user.authenticate(opts[:password])
      remember_me_setup(opts, @user)
      user_login(@user)
      redirect_to (session[:tgt_path] || root_path), :notice => 'Logged in!'
    else
      @user = User.new
      flash.now.alert = 'Invalid user name or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id]   = nil
    session[:user_name] = nil
    cookies[:remember_me_token] = nil
    redirect_to root_path, :notice => 'Logged out!'
  end

  private

  def remember_me_setup(params, user)
    if params['remember_me'] == '1'
      cookies[:remember_me_token] = {:value => user.remember_me_token, :expires => Time.now + 6.weeks}
    else
      cookies[:remember_me_token] = nil
    end
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
    return if current_membership.blank?
    new_memb = current_membership
    new_memb.sign_in_count = Integer(new_memb.sign_in_count) + 1
    new_memb.last_sign_in_at = Time.now
    new_memb.save
  end

end
