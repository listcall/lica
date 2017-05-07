pOpts =
  container: 'body'

xOpts = (title)-> { container: 'body', title: title }

closeTooltips = ()->
  console.log "CLOSING"
  $('a').tooltip('hide')

$(document).ready ->
  $('.pCount').tooltip(pOpts)
  $('.btnRsvp').tooltip   xOpts('send an RSVP invite to the entire team')
  $('.btnNotify').tooltip xOpts('send a Notification to event participants')
  $('.btnLeave').tooltip  xOpts('send a "Left Home" message to event participants')
  $('.btnReturn').tooltip xOpts('send a "Returned Home" message to event participants')
  $('a').click closeTooltips

