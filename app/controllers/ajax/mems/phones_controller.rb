class Ajax::Mems::PhonesController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html
  layout false

  def index
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    phones = user.phones
    respond_with phones
  end

  def new
    @member = current_team.memberships.find(params[:membership_id])
    @user   = @member.user
    @phone  = User::Phone.new(visible: true, pagable: true)
    respond_with @phone
  end

  def create
    @member = current_team.memberships.find(params[:membership_id])
    @user   = @member.user
    opts    = {user_id: @user.id}.merge(params.to_unsafe_h[:phone])
    @phone  = User::Phone.new(opts)
    if @phone.valid? && @phone.save
      @phone.move_to_top
      render plain: 'OK'    # JS will re-load the page...
    else
      render :new, status: 400
    end
  end

  def update
    field = params['name']
    value = params['value']
    phone = User::Phone.find(params['id'])
    phone.update_attributes({field => value})
    if phone.valid?
      render json: {success: true}.to_json, status: 200, layout: false
    else
      msg = phone.errors.messages.to_json.gsub(/[\[\]\"\{\}]/,'').gsub(':',': '),gsub(',',', ')
      render json: msg, layout: false, status: 400
    end
  end

  def destroy
    memid = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    phone = user.phones.find(params[:id])
    respond_with phone.destroy
  end

  def sort
    params['phone'].each_with_index do |phone_id, idx|
      phone = User::Phone.find(phone_id)
      phone.update_attributes(position: idx+1)
    end
    render plain: 'OK', layout: false
  end

  private

  def random_phone_number
    base = rand(36**5).to_s
    mid  = base[0..2]
    fin  = base[3..6]
    "666-666-#{fin}"
  end

end
