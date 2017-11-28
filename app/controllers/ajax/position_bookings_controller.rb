class Ajax::PositionBookingsController < ApplicationController

  before_action :authenticate_member!

  respond_to :json, :html
  layout false

  def update
    directive = params[:directive]
    year, opts, week, memid, posid = params[:id].split('-')
    options  = {year: year, quarter: opts, week: week, position_id: posid}
    period   = Position::Period.where(options).try(:first)
    new_opts = {position_period_id: period.id, membership_id: memid}
    case directive
    when 'select'
        booking = period.bookings.where(membership_id: memid).to_a.first
        if booking.blank?
          Position::Booking.create(new_opts)
        else
          booking.update_attributes(new_opts)
        end
      when 'unselect'
        booking = Position::Booking.where(new_opts).try(:first)
        booking.try(:destroy)
    end
    @position  = Position.find(posid)
    @quarter   = options.clone
    @sched_set = (1..13).map do |num|
      opts = @quarter.clone
      opts[:week] = num
      Position::Period.find_or_create_by(opts)
    end
    render partial: 'positions/schedule', layout: false
  end

end
