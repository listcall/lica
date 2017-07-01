allDayTrue = ->
  doAjax {name: 'all_day', value: true}

allDayFalse = ->
  opts =
    'event[all_day]'     : false
    'event[start_time]'  : $('#startTime').editable('getValue').start_time
    'event[finish_time]' : $('#finishTime').editable('getValue').finish_time
  doAjax opts

switchChanged = (e)->
  if $('#dayChx').is(":checked")
    allDayTrue()
  else
    allDayFalse()

$(document).ready ->
  $('#dayChx').change switchChanged
