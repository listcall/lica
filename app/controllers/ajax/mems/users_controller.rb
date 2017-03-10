class Ajax::Mems::UsersController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json

  def index
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    phones = user.phones
    respond_with phones
  end

  def create
    memid  = params[:membership_id]
    member = current_team.memberships.find(memid)
    user   = member.user
    phone  = User::Phone.create(user_id: user.id, number: '666-666-6666', pagable: '0', typ: 'Mobile')
    phone.move_to_top
    respond_with phone
  end

  def update
    # devlog "STARTING UPDATE"
    # devlog params
    field, value  = [params['name'], params['value']]
    memid  = params[:membership_id]
    select_vals   = if field.blank?
                      dev_log 'SINGLE ENTITY UPDATE'
                      {field => value}
                    else
                      dev_log 'MULTI ENTITY UPDATE'
                      permitted(params['value'])
                    end
    user = current_team.memberships.find(memid).user
    user.update(select_vals)
    if user.valid? && user.save
      dev_log 'UPDATE WAS SUCCESSFUL'
      respond_with true
    else
      dev_log 'UPDATE WAS NOT SUCCESSFUL'
      user.errors.messages.keys.each { |key| user.errors.add key, user.errors[key].first}
      dev_log 'ERRORS:', validation_message(user)
      render text: validation_message(user), status: 400
    end

  end

  private

  def validation_message(obj)
    count = obj.errors.count
    return 'Invalid data - please try again.' if count == 0
    obj.errors.full_messages.map.with_index {|msg, i| "#{msg}"}.join(', ')
  end

  def permitted(vals)
    vals.permit :title, :first_name, :middle_name, :last_name
  end

  def validation_message(obj)
    count = obj.errors.count
    return 'Invalid data - please try again.' if count == 0
    obj.errors.full_messages.map.with_index {|msg, i| "#{msg}"}.uniq.join(', ')
  end

end
