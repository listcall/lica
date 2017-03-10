class Ajax::QualCtypesAttendanceController < ApplicationController

  before_action :authenticate_owner!
  layout false

  def show
    @ctype = QualCtype.find(params[:id])
    @tags  = current_team.events.tag_uniq.join(', ')
    @types = current_team.event_types.keys.join(', ')
    @rule = begin
      JSON.parse(@ctype.attendance_rule)
    rescue
      {}
    end
  end

  def update
    ctype = QualCtype.find(params[:id])
    data  = params.slice :event_count, :month_count, :title, :types, :tags
    data['types'] = data['types'] && data['types'].gsub(',',' ').upcase
    data['tags']  = data['tags']  && data['tags'].gsub(',',' ').downcase
    ctype.attendance_rule = data.to_json
    ctype.save
    opts = {qual_ctype_id: ctype.id}
    instrument 'ctype_attendance_rule.update', opts
    render text: 'OK'
  end
end
