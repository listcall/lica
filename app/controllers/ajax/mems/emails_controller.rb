class Ajax::Mems::EmailsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html
  layout false

  def index
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    emails = user.emails
    respond_with emails
  end

  def new
    @member = current_team.memberships.find(params[:membership_id])
    @user   = @member.user
    @email  = User::Email.new(visible: true, pagable: true)
    respond_with @email
  end

  def create
    @member = current_team.memberships.find(params[:membership_id])
    @user   = @member.user
    opts    = {user_id: @user.id}.merge(params.to_unsafe_h[:email])
    @email  = User::Email.new(opts)
    if @email.valid? && @email.save
      @email.move_to_top
      render plain: 'OK'    # JS will re-load the page...
    else
      render :new, status: 400
    end
  end

  def update
    field = params['name']
    value = params['value']
    email = User::Email.find(params['id'])
    email.update_attributes({field => value})
    if email.valid?
      render json: {success: true}.to_json, status: 200, layout: false
    else
      msg = email.errors.messages.to_json.gsub(/[\[\]\"\{\}]/,'').gsub(':',': ')
      render json: msg, layout: false, status: 400
    end
  end

  def destroy
    memid = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    email = user.emails.find(params[:id])
    respond_with email.destroy
  end

  def sort
    params['email'].each_with_index do |email_id, idx|
      User::Email.find(email_id).update_attributes(position: idx+1)
    end
    render plain: 'OK', layout: false
  end

  def random_email
    length = 8
    str = rand(36**8).to_s(36)
    "temp_#{str}@tbd.com"
  end

end
