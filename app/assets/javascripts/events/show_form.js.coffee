eventObj = ->
  key = $('#event_typ').editable('getValue').typ
  obj = JSON.parse(lclData.eTypes)[key]

defaultStart = ->
  eventObj()['default_start_time']

defaultFinish = ->
  eventObj()['default_finish_time']

showTime = ->
  $('.time-field').show()

hideTime = ->
  $('.time-field').hide()

displayTime = ->
  if $('#dayChx').is(':checked')
    hideTime()
  else
    showTime()

updateTime = ->
  unless $('#dayChx').is(':checked')
    $('#startTime').editable('setValue', defaultStart(), false)
    $('#finishTime').editable('setValue', defaultFinish(), false)
    $('#startTime').addClass('editable-unsaved')
    $('#finishTime').addClass('editable-unsaved')

$(document).ready ->
  displayTime()
  $('#dayChx').change ->
    updateTime()
    displayTime()

# ----- clear buttons -----

clearLeaders = ->
  $('#leaders').editable('setValue', '', false)
  doAjax({name: 'leaders', value: ''})

clearLocAdr = ->
  $('#location_address').editable('setValue', '', false)
  doAjax({name: 'location_address', value: ''})

clearLatLon = ->
  $('#lat').editable('setValue', '', false)
  $('#lon').editable('setValue', '', false)
  doAjax({'event[lat]' : '', 'event[lon]' : ''})

$(document).ready ->
  $('#clearLeaders').click -> clearLeaders()
  $('#clearLocAdr').click  -> clearLocAdr()
  $('#clearLatLon').click  -> clearLatLon()









