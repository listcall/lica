#= require ./index_tag_manager

# ----- utilities -----

momentFmt = "YYYY-MM-DD HH:mm"
timeFmt = "%Y-%m-%d %H:%M"
hourFmt = "%H:%M"

randomId = ->
  Math.random().toString(36).substring(7)

isAllDay = (start, end)->
  return true if start.strftime(hourFmt) == end.strftime(hourFmt) == "00:00"
  return true if start.strftime(hourFmt) == "00:00" && finish == null
  false

# ----- create event -----

createEvent = (start, end)->
  $('#eventModal').find('.modal-title').text("Create a new Work Period")
  $('#deleteEvent').hide()
  $('#updateEvent').hide()
  $('#createEvent').show().unbind().click -> processCreateForm(start, end)
  clearAllMemberTags()
#  recurPicker.resetState()
  $('#eventModal').modal('show')
  $('#memberTagInput').focus()

processCreateForm = (start, end)->
  $('#eventModal').modal('hide')
  name_f  = $('#memberTagNames').val()
#  rule_f  = JSON.stringify recurPicker.toHash()
  rule_f  = '{"rule_type":"Never"}'
  createId = randomId()
  if (name_f)
    obj = {
      id     : createId
      title  : name_f
      start  : start
    }
    ajaxObj = {
      names         : name_f
      start         : start.format(momentFmt)
      rule          : rule_f
    }
    if isAllDay(start, end)
      obj.allDay      = true
      ajaxObj.all_day = true
    else
      obj.end        = end
      ajaxObj.finish = end.format(momentFmt)
    result = cal.fullCalendar('renderEvent', obj)
    $.ajax
      method : 'post'
      url    : "/services/#{lclData.serviceId}/periods"
      data   : ajaxObj
      success: (events)->
        old_event = cal.fullCalendar('clientEvents', createId)[0]
        cal.fullCalendar('removeEvents', [old_event.id])
        _.each events, (new_event)->
          cal.fullCalendar('renderEvent', new_event)
      failure: ->
        console.log "there was failure"
  cal.fullCalendar('unselect')

# ----- edit event -----

populateTypeAhead = (event)->
  clearAllMemberTags()
  _.each event.title.split(', '), (name)->
    data = _.find lclData.memList, (data)-> data["user_name"] == name
    addMemberTag(data) if data

editEvent = (event)->
  $('#eventModal').find('.modal-title').text("Update a Work Period")
  $('#deleteEvent').show().unbind().click -> confirmThenDeleteEvent(event)
  $('#updateEvent').show().unbind().click -> processEditForm(event)
  $('#createEvent').hide()
  populateTypeAhead(event)
#  recurPicker.updateState(event.rule)
  $('#eventModal').modal('show')
  $('#memberTagInput').focus()

processEditForm = (event)->
  $('#eventModal').modal('hide')
  name_f  = $('#memberTagNames').val()
  #rule_f  = JSON.stringify recurPicker.toHash()
  rule_f = '{"rule_type":"Never"}'
  oldId = event.id
  ajaxObj = {
    names: name_f
    rule: rule_f
  }
  $.ajax
    method : 'put'
    url    : "/services/#{lclData.serviceId}/periods/#{event.id}"
    data   : ajaxObj
    failure: -> console.log "FAILED"
    success: (events)->
      cal.fullCalendar('removeEvents', [oldId])
      _.each events, (newEvent)-> cal.fullCalendar('renderEvent', newEvent)

# ----- move / resize event -----

ajaxRepositionEvent = (event)->
  data =
      start   : event.start.format(momentFmt)
      xstart  : event.xstart
      all_day : event.allDay
  data.finish  = event.end.format(momentFmt) if event.end?
  data.xfinish = event.xend if event.xend?
  console.log "REPO", data
  $.ajax
    method : 'put'
    url    : "/services/#{lclData.serviceId}/periods/#{event.id}"
    data   : data
    success: -> console.log "IT WORKED"
    failure: -> console.log "FAILED"

moveEvent = (event)->
  ajaxRepositionEvent(event)

resizeEvent = (event)->
  ajaxRepositionEvent(event)

# ----- delete event -----

confirmThenDeleteEvent = (event)->
  deleteEvent(event) if confirm("Delete this period?")

deleteEvent = (event)->
  $.ajax
    method : 'delete'
    url    : "/services/#{lclData.serviceId}/periods/#{event.id}"
#    success: -> console.log "THERE WAS SUCCESS"
#    failure: -> console.log "there was failure"
  cal.fullCalendar('removeEvents', [event.id])
  $('#eventModal').modal('hide')

# ----- highlight event sequence -----

mouseOverEvent = (h_event, js_event)->
  return if h_event.hovering
  h_event.hovering = true
  tgtId  = h_event.id
  $(".evid#{tgtId}").addClass('greenGlow')

mouseOutEvent  = (h_event, js_event)->
  h_event.hovering = false
  $(".fc-event").removeClass('greenGlow')

eventRender = (event, jq_event) ->
  $(jq_event).addClass("evid" + "#{event.id}")

# ----- configure and launch calendar -----

fcOpts =
  header:
    left: 'prev,next today'
    center: 'title'
    right: 'month,agendaWeek,agendaDay'
  selectable: true
  editable  : true
  height    : 500
  events    : "/services/#{lclData.serviceId}/periods.json"
  selectHelper          : true
  eventStartEditable    : true
  eventDurationEditable : true
  defaultTimedEventDuration: "02:00:00"
  defaultAllDayEventDuration: { days: 1 }
  forceEventDuration: true
  eventClick  : editEvent
  eventDrop   : moveEvent
  eventResize : resizeEvent
  select      : createEvent
  eventRender : eventRender
  eventMouseover : mouseOverEvent
  eventMouseout  : mouseOutEvent

$(document).ready ->
  window.cal = $('#calHere').fullCalendar(fcOpts)