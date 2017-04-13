class Ajax::Mems::AddressesController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html
  layout false

  def index
    memid     = params[:membership_id]
    member    = current_team.memberships.find(memid)
    user      = member.user
    addresses = user.addresses
    respond_with addresses
  end

  def new
    @member   = current_team.memberships.find(params[:membership_id])
    @user     = @member.user
    @address  = User::Address.new(visible: true)
    respond_with @address
  end

  def create
    memid    = params[:membership_id]
    member   = current_team.memberships.find(memid)
    user     = member.user
    opts = {user_id: user.id}.merge(params[:address])
    @address = User::Address.new(opts)
    if @address.valid? && @address.save
      @address.move_to_top
      render plain: 'OK'
    else
      render :new, status: 400
    end
  end

  def destroy
    memid   = params[:membership_id]
    member  = current_team.memberships.find(memid)
    user    = member.user
    address = user.addresses.find(params[:id])
    respond_with address.destroy
  end

  def sort
    params['address'].each_with_index do |address_id, idx|
      User::Address.find(address_id).update_attributes(position: idx+1)
    end
    render plain: 'OK', layout: false
  end

  def update
    dev_log 'STARTING UPDATE'
    dev_log params
    field, value  = [params['name'], params['value']]
    select_vals   = unless field.blank?
                      dev_log 'SINGLE ENTITY UPDATE'
                      {field => value}
                    else
                      dev_log 'MULTI ENTITY UPDATE'
                      permitted(params['value'])
                    end
    addr = User::Address.find(params['id'])
    addr.update(select_vals)
    if addr.valid? && addr.save
      dev_log 'UPDATE WAS SUCCESSFUL'
      respond_with true
    else
      dev_log 'UPDATE WAS NOT SUCCESSFUL'
      addr.errors.messages.keys.each { |key| addr.errors.add key, addr.errors[key].first}
      dev_log 'ERRORS:', validation_message(addr)
      render plain: validation_message(addr), status: 400
    end
  end

  private

  def permitted(vals)
    vals.permit :address1, :address2, :city, :state, :zip
  end

  def validation_message(obj)
    count = obj.errors.count
    return 'Invalid data - please try again.' if count == 0
    obj.errors.full_messages.map.with_index {|msg, i| "#{msg}"}.uniq.join(', ')
  end

end
