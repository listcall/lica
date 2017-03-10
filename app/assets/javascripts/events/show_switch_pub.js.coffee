# note this ajax call relies on the CSRF token
# being set in show_ajax.js.coffee...
updateServer = (val)->
  $.ajax
    url: "/ajax/events/#{lclData.eventId}"
    type: 'put'
    data: {name: 'published', value: val}

switchChanged = (e)->
  val = $('#pubChx').is(":checked")
  updateServer(val)

$(document).ready ->
  $('#pubChx').change switchChanged
