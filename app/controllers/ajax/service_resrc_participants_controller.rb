class Ajax::ServiceResrcParticipantsController < ApplicationController

  before_action :authenticate_member!

  respond_to :json, :html
  layout false

  def update
    directive = params[:directive]
    year, quarter, week, memid, svcid = params[:id].split('-')
    options  = {year: year, quarter: quarter, week: week, service_id: svcid}
    period   = ServicePeriod.where(options).try(:first)
    new_opts = {service_period_id: period.id, membership_id: memid}
    case directive
      when 'select'
        provider = period.service_participants.where(membership_id: memid).first
        if provider.blank?
          ServiceParticipant.create(new_opts)
        else
          provider.update_attributes(new_opts)
        end
      when 'unselect'
        assignment = ServiceParticipant.where(new_opts).try(:first)
        assignment.try(:destroy)
    end
    svc_id = period.service.id
    @sched_set = (1..13).map do |num|
      quarter = options.except(:service_id)
      quarter[:week]       = num
      quarter[:service_id] = svc_id
      ServicePeriod.find_or_create(quarter)
    end
    render partial: 'service_cal_resrcs/resrc_rost', layout: false
  end

end
