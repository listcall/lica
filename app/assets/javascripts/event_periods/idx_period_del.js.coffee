# note this ajax call relies on the CSRF token
# being set in config_ajax.js.coffee...
updateServer = (perId)->
  console.log "updating server", perId
  $.ajax
    url     : "/ajax/events/#{lclData.eventId}/event_periods/#{perId}"
    type    : "delete"
    success : -> location.reload()
    error   : -> location.reload()

delPeriod = (ev)->
  console.log "clicked on delPeriod"
  perId = $(ev.currentTarget).data('perid')
  updateServer(perId)

$(document).ready ->
  $('.perDel').click(delPeriod)
