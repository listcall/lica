showAll = ->
  $('.eventClick').text('hide')
  $('.eventRecords').show()

hideAll = ->
  $('.eventClick').text('show')
  $('.eventRecords').hide()

hideEl = (el)->
  aspect = el.id.split('_')[1]
  $("#click_#{aspect}").text('show')
  $("#event_#{aspect}").hide()

showEl = (el)->
  aspect = el.id.split('_')[1]
  $("#click_#{aspect}").text('hide')
  $("#event_#{aspect}").show()

toggleEventDisplay = (ev)->
  ev.preventDefault()
  el = ev.target
  val = $(el).text()
  if val == "show"
    hideAll()
    showEl(el)
  else
    hideEl(el)

$(document).ready ->
  $('.eventClick').click toggleEventDisplay
  $('#showAllActivities').click (ev)->
    ev.preventDefault()
    showAll()
  $('#hideAllActivities').click (ev)->
    ev.preventDefault()
    hideAll()