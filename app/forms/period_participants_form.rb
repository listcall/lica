class PeriodParticipantsForm

  include ActiveModel::Model

  attr_reader   :service_period, :service_period_list, :service_participants
  attr_accessor :rules, :names, :start, :finish, :all_day, :service_id
  attr_accessor :schedule_txt, :count, :until

  def initialize(params = {})
    @params     = params
    @rules      = params[:rules      ]
    @names      = params[:names      ]
    @start      = params[:start      ]
    @all_day    = params[:all_day    ]
    @service_id = params[:service_id ]
  end

  def self.create(params)
    instance = allocate
    instance.initialize(params)
    instance.save
    instance
  end

  def update(params)
  end

  def destroy
  end

  def save
    @service_participants.save
    @service_period_list.save if @service_period_list
    @service_participants.each { |part| part.save }
  end

  private

  def service
    @service ||= Service.find(service_id)
  end

  def add_provider(provider)
    provider.service_period_id = period.id
    provider.save
  end

  def del_provider(provider)
    provider.destroy
  end

  # def update(params)
  #   id = params["id"]
  #   name = params["name"]
  #   role = @current_team.event_roles[id]
  #   if role.nil?
  #     devlog "ROLE IS NIL!"
  #     return
  #   end
  #   update_membership_roles(role.label, params["value"]) if name == "label"
  #   role.send("#{name}=", params["value"])
  #   roles = @current_team.event_roles
  #   roles.destroy id
  #   roles.add_obj role
  #   @current_team.event_roles = roles
  #   @current_team.save
  # end
  #
  # def destroy(params)
  #   if params[:id]
  #     roles = @current_team.event_roles
  #     roles.destroy params[:id]
  #     @current_team.event_roles = roles
  #     @current_team.save
  #   end
  # end

  # ----- active model support -----

  def persisted?; false; end

end
