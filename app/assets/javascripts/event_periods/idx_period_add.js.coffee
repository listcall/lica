# note this ajax call relies on the CSRF token
# being set in config_ajax.js.coffee...
updateServer = (data)->
  console.log "updating server", data
  $.ajax
    url    : "/ajax/events/#{lclData.eventId}/event_periods"
    type   : "post"
    data   : data
    success: -> location.reload()
    error  : -> location.reload()

addPeriod = (ev)->
  data = {
    tgt_event_id: $(ev.currentTarget).data('eventid')
    position: $(ev.currentTarget).data('posn')
  }
  updateServer(data)

$(document).ready ->
#  $('.perAdd').hover(hoverIn, hoverOut)
  $('.perAdd').click(addPeriod)
