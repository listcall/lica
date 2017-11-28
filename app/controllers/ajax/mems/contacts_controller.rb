class Ajax::Mems::ContactsController < ApplicationController

  before_action :authenticate_member!

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
    @contact  = User::EmergencyContact.new(visible: true)
    respond_with @contact
  end

  def create
    memid    = params[:membership_id]
    member   = current_team.memberships.find(memid)
    user     = member.user
    opts = {user_id: user.id}.merge(params.to_unsafe_h[:contact])
    @contact = User::EmergencyContact.new(opts)
    if @contact.valid? && @contact.save
      @contact.move_to_top
      render plain: 'OK'
    else
      render :new, status: 400
    end
  end

  def destroy
    memid   = params[:membership_id]
    member  = current_team.memberships.find(memid)
    user    = member.user
    contact = user.emergency_contacts.find(params[:id])
    respond_with contact.try(:destroy)
  end

  def sort
    params['contact'].each_with_index do |contact_id, idx|
      User::EmergencyContact.find(contact_id).update_attribute(:position, idx+1)
    end
    render plain: 'OK', layout: false
  end

  def update
    dev_log 'STARTING UPDATE'
    field, value  = [params['name'], params['value']]
    select_vals   = unless field.blank?
                      dev_log 'SINGLE ENTITY UPDATE'
                      {field => value}
                    else
                      dev_log 'MULTI ENTITY UPDATE'
                      permitted(params['value'])
                    end
    contact = User::EmergencyContact.find(params['id'])
    contact.update(select_vals)
    if contact.valid? && contact.save
      dev_log 'UPDATE WAS SUCCESSFUL'
      respond_with true
    else
      dev_log 'UPDATE WAS NOT SUCCESSFUL'
      contact.errors.messages.keys.each { |key| contact.errors.add key, contact.errors[key].first}
      dev_log 'ERRORS:', validation_message(contact)
      render plain: validation_message(contact), status: 400
    end
  end

  private

  def permitted(vals)
    vals.permit :name, :kinship
  end

  def validation_message(obj)
    count = obj.errors.count
    return 'Invalid data - please try again.' if count == 0
    obj.errors.full_messages.map.with_index {|msg, i| "#{msg}"}.uniq.join(', ')
  end

end
