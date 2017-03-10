eventObj = ->
  key = $('#event_typ').val()
  obj = JSON.parse(lclData.eTypes)[key]

defaultStart = ->
  eventObj()['default_start_time']

defaultFinish = ->
  eventObj()['default_finish_time']

showTime = ->
  $('#startTime').val(defaultStart())     unless lclData.isCopy
  $('#finishTime').val(defaultFinish())   unless lclData.isCopy
  $('.time-width').show()

hideTime = ->
  $('.time-width').hide()
  $('.time-width').val('')

setTime = ->
  if $('#dayChx').is(':checked')
    hideTime()
  else
    showTime()

$(document).ready ->
  setTime()
  $('#dayChx').change -> setTime()









