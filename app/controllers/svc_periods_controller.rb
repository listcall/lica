# class SvcPeriodsController < ApplicationController
#
#   include IceCube
#   include SvcUtil
#   before_action :authenticate_reserve!
#
#   def index
#     @start   = params[:start] || Time.now - 1.month
#     @finish  = params[:end]   || Time.now + 1.month
#     ids      = current_team.svcs.pluck(:id) + partner_service_ids
#     @services = current_team.svcs
#     @ser_pars = service_partner_setup
#     @plans = Svc::Plan.where(svc_id: ids).active_between @start, @finish
#   end
#
#   def show
#     @service  = ServiceDecorator.new(Service.find(params[:service_id]))
#     @ser_pars = service_partner_setup
#     @member   = current_team.memberships.by_user_name(params[:id]).to_a.first
#   end
#
#   def create
#     variable = valid_create_params(params)
#     plan = Svc::Plan.create(variable)
#     add_members(plan, params[:names])
#     plan.schedule_obj = gen_schedule_obj(params)
#     plan.save
#     plan.reload
#     base      = Time.parse(params[:start])
#     @start    = base - 1.month
#     @finish   = base + 1.month
#     @plans    = [plan]
#     render :index
#   end
#
#   def update
#     plan = Svc::Plan.find(params[:id])
#     plan.update_attributes(valid_update_params(params))
#     add_members(plan, params[:names]) if params[:names]
#     plan.schedule_obj = gen_schedule_obj(params) if params[:rule]
#     plan.save
#     plan.reload
#     base    = Time.now        # TODO: pass current month...
#     @start  = base - 1.month
#     @finish = base + 1.month
#     @plans  = [plan]
#     render :index
#   end
#
#   def destroy
#     plan = Svc::Plan.find(params[:id])
#     plan.destroy unless plan.blank?
#     render plain: 'OK'
#   end
#
#   private
#
#   def add_members(plan, names)
#     plan.member_ids = []
#     names.split(',').each do |name|
#       member = current_team.memberships.by_user_name(name.strip).first
#       next if member.blank?
#       plan.add_member(member)
#     end
#   end
#
#   def valid_create_params(params)
#     params.permit(:start, :finish, :svc_id, :service_id)
#   end
#
#   def valid_update_params(params)
#     params.permit(:svc_id, :start, :finish)
#   end
#
#   def gen_schedule_obj(params)
#     obj  = Schedule.new
#     rule = JSON.parse(params['rule'])
#     return obj if rule['rule_type'] == 'Never'
#     if rule['until']
#       rule['until'] = Time.parse(rule['until'])
#     end
#     obj.add_recurrence_rule Rule.from_hash(rule)
#     obj
#   end
# end
