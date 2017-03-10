#= require ./tooltips


doAjax = (typeId, qualId, state)->
  console.log typeId, qualId, state
  obj = {
    qual_ctype_id:  typeId
    qual_id:        qualId
    state:          state
  }
  $.ajax
    method: 'post'
    url:    '/admin/qual_assignments'
    data:   obj

nextState = (state)->
  switch state
    when "unused" then "optional"
    when "optional" then "required"
    else "unused"

clickEl = (ev, state)->
  newState = nextState(state)
  $tgt = $(ev.target)
  $par = $tgt.parent()
  $nxt = $par.find(".#{newState}Icon")
  $tgt.hide()
  $nxt.show()
  [_lbl, typeId, qualId] = $par.attr('id').split('_')
  doAjax(typeId, qualId, newState)
  resetTooltips()

$(document).ready ->
  $('.unusedIcon').click   (ev)-> clickEl(ev, 'unused')
  $('.optionalIcon').click (ev)-> clickEl(ev, 'optional')
  $('.requiredIcon').click (ev)-> clickEl(ev, 'required')