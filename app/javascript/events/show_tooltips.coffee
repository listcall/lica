pOpts =
  container: 'body'

rOpts =
  container: 'body'
  title:     'send an RSVP invite to the entire team'

nOpts =
  container: 'body'
  title:     'send a Notification to event participants'

$(document).ready ->
  $('.pCount').tooltip(pOpts)
  $('.btnRsvp').tooltip(rOpts)
  $('.btnNotify').tooltip(nOpts)
