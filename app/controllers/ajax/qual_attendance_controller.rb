class Ajax::QualAttendanceController < ApplicationController

  layout false

  def show
    @mem_cert = MembershipCert.find(params[:id])
    @ctype    = @mem_cert.ctype
    @member   = @mem_cert.membership
    @rule     = @ctype.attendance_val
    @title    = @rule.title
    @types    = @rule.types.split(' ')
    @tags     = @rule.tags.split(' ')
    @periods  = AttendanceSyncSvc.new.limited_attendance_for(@member, @ctype)
    @events   = @periods.map {|x| x.event}
  end
end
