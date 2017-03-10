#= require ./index_tag_manager
#= require ./index_re_view

RC = require('svc_cals/re_view/components')

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

# ----- serviceSelect for create/edit -----

radio = (service, checked='false')->
  chkStr = if checked == "true" then "checked" else ""
  """
  <label>
  <input type="radio" name="svcId" value="#{service.id}" #{chkStr}>
  #{service.name}
  </label>
  """

defaultSvcId = (event)->
  listId = lclData.svcList[0].id
  return event?.svc_id if event?.svc_id
  return listId unless (cookieId = $.cookie('svcId'))
  return listId unless _.find lclData.svcList, (svc)->
    String(cookieId) == String(svc.id)
  cookieId

  if (ck = $.cookie('svcId')) && lclData.svcList then ck else 'month'

serviceSelect = (event = {})->
  checkId = defaultSvcId(event)
  radios = _.map lclData.svcList, (svc)->
    chk = if String(svc.id) == String(checkId) then "true" else "false"
    radio(svc, chk)
  """
  <div class="radio">
    #{radios.join()}
  </div>
  """

# ----- typeahead -----

populateTypeAhead = (event)->
  clearAllMemberTags()
  _.each event.title.split(', '), (name)->
    data = _.find lclData.memList, (data)-> data["user_name"] == name
    addMemberTag(data) if data

# ----- create event -----

createEvent = (start, end)->
  return unless lclData.editable
  $('#eventModal').find('.modal-title').text("Create a new Work Period")
  $('#deleteEvent').hide()
  $('#updateEvent').hide()
  $('#serviceSelect').html(serviceSelect())
  $('#createEvent').show().unbind().click ->
    obj  = timePicker.toHash()
    hour = (str)-> str.split(':')[0]
    min  = (str)-> str.split(':')[1]
    end.month(start.month()).date(start.date())
    newStart = start.hour(hour(obj.start)).minute(min(obj.start))
    newEnd   = end.hour(hour(obj.finish)).minute(min(obj.finish))
    processCreateForm(newStart, newEnd)
  clearAllMemberTags()
  startTime = start.format("hh:mm")
  endTime   = end.format("hh:mm")
  if startTime == endTime
    startTime = "12:00"
    endTime   = "14:00"
  timePicker.updateState({start: startTime, finish: endTime})
  recurPicker.resetState()
  $('#eventModal').modal('show')
  $('#memberTagInput').focus()

processCreateForm = (start, end)->
  $('#eventModal').modal('hide')
  name_f  = $('#memberTagNames').val()
  rule_f  = JSON.stringify recurPicker.toHash()
  svc_id  = $('input[name=svcId]:checked').val()
  $.cookie('svcId', svc_id, {expires:7, path: '/'})
  createId = randomId()
  if (name_f)
    obj = {
      id     : createId
      title  : name_f
      start  : start
      end    : end
    }
    ajaxObj = {
      svc_id : svc_id
      names  : name_f
      start  : start.format(momentFmt)
      finish : end.format(momentFmt)
      rule   : rule_f
    }
    result = cal.fullCalendar('renderEvent', obj)
    $.ajax
      method : 'post'
      url    : "/svc_periods"
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

editEvent = (event)->
  return unless lclData.editable
  $('#eventModal').find('.modal-title').text("Update a Work Period")
  $('#deleteEvent').show().unbind().click -> confirmThenDeleteEvent(event)
  $('#updateEvent').show().unbind().click -> processEditForm(event)
  $('#serviceSelect').html(serviceSelect(event))
  $('#createEvent').hide()
  populateTypeAhead(event)
  startTime = event.xstart.split(' ')[1]
  endTime   = event.xend.split(' ')[1]
  timePicker.updateState({start: startTime, finish: endTime})
  recurPicker.updateState(event.rule)
  $('#eventModal').modal('show')
  $('#memberTagInput').focus()

processEditForm = (event)->
  $('#eventModal').modal('hide')
  name_f  = $('#memberTagNames').val()
  rule_f  = JSON.stringify recurPicker.toHash()
  oldId   = event.id
  svc_id  = $('input[name=svcId]:checked').val()
  eTimes  = timePicker.toHash()
  hourFor = (val)-> val.split(':')[0]
  minFor  = (val)-> val.split(':')[1]
  $.cookie('svcId', svc_id, {expires:7, path: '/'})
  ajaxObj = {
    svc_id: svc_id
    names : name_f
    rule  : rule_f
    start : event.xstart.split(' ')[0] + ' ' + eTimes.start
    finish: event.xstart.split(' ')[0] + ' ' + eTimes.finish
  }
  $.ajax
    method : 'put'
    url    : "/svc_periods/#{event.id}"
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
  $.ajax
    method : 'put'
    url    : "/svc_periods/#{event.id}"
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
    url    : "/svc_periods/#{event.id}"
    success: -> console.log "THERE WAS SUCCESS"
    failure: -> console.log "there was failure"
  cal.fullCalendar('removeEvents', [event.id])
  $('#eventModal').modal('hide')

# ----- highlight event sequence -----

mouseOverEvent = (h_event, js_event)->
  return unless lclData.editable
  return if h_event.hovering
  h_event.hovering = true
  tgtId  = h_event.id
  $(".evid#{tgtId}").addClass('greenGlow')

mouseOutEvent  = (h_event, js_event)->
  return unless lclData.editable
  h_event.hovering = false
  $(".fc-event").removeClass('greenGlow')

eventRender = (event, jq_event) ->
  $(jq_event).addClass("evid" + "#{event.id}")

# ----- configure and launch calendar -----

calView = if (ck = $.cookie('calView')) then ck else 'month'

fcOpts = ->
  weekHeight = window.innerHeight - 150
  value =
    timeFormat: 'H(:mm)'
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,custom'
    views:
      month:
        eventLimit: 5
      agenda:
        eventLimit: 3
      fourDay:
        type:       'basic'
        duration:   {weeks: 1}
        buttonText: '1wk'
      custom:
        duration: {weeks: 1}
        buttonText: "plan"
    selectable   : lclData.editable
    editable     : lclData.editable
    height       : weekHeight
    events       : "/svc_periods.json"
    selectHelper : lclData.editable
    eventStartEditable    : lclData.editable
    eventDurationEditable : lclData.editable
    defaultTimedEventDuration  : "02:00:00"
    defaultAllDayEventDuration : { days: 1 }
    forceEventDuration         : true
    allDaySlot  : false
    eventClick  : editEvent
    eventDrop   : moveEvent
    eventResize : resizeEvent
    select      : createEvent
    eventRender : eventRender
    eventColor  : lclData.eventColor
    eventTextColor : '#000000'
    eventMouseover : mouseOverEvent
    eventMouseout  : mouseOutEvent
    defaultView    : calView
    windowResize   : (view)-> reRenderCal()
    viewRender     : (view, _el)->
      $.cookie('calView', view.name, {expires:7, path: '/'})

renderCal = ->
  window.cal = $('#calHere').fullCalendar(fcOpts())
  $('table.res tbody').height(window.innerHeight - 250)

reRenderCal = ->
  $('table.res tbody').height(window.innerHeight - 250)
  $('#calHere').fullCalendar('option', 'height', window.innerHeight - 150)
  window.cal = $('#calHere').fullCalendar('render')

$(document).ready ->
  renderCal()
  rule = {rule_type: "IceCube::DailyRule", interval: 5, count: 8}
  window.recurElement = React.createElement(window.Picker.Recur, {rule: rule})
  window.recurPicker  = React.render(window.recurElement, $('#recurSet')[0])
  window.timeElement  = React.createElement(window.Picker.Time, {start: 6, finish: 20})
  window.timePicker   = React.render(window.timeElement  , $('#timeSet')[0])