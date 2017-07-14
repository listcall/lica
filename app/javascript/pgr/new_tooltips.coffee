pOpts =
  container: 'body'

xOpts = (title)-> { container: 'body', title: title }

closeTooltips = -> $('.btn').blur()

$(document).ready ->
  $('.pCount').tooltip(pOpts)
  $('.btnRSVP').tooltip   xOpts('send selected message to team')
  $('.btnHeads_up').tooltip   xOpts('send "Heads Up" message to team')
  $('.btnImmediate_callout').tooltip   xOpts('send "Immediate Callout" message to team')
  $('.btnDelayed_callout').tooltip   xOpts('send "Delayed Callout" message to team')
  $('.btnNotify').tooltip xOpts('send notification to event participants')
  $('.btnLeave').tooltip  xOpts('send "Left Home" message to event participants')
  $('.btnReturn').tooltip xOpts('send "Returned Home" message to event participants')
  $(window).focus closeTooltips

