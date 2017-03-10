# note this ajax call relies on the CSRF token
# being set in config_ajax.js.coffee...
updateServer = (data, parent, child)->
  $.ajax
    url    : "/ajax/events/#{lclData.eventId}/event_periods/#{data.parent_id}"
    type   : "put"
    data   : data
    success: (val)-> $(child).replaceWith(val); resetHighlights(parent);
    error  : (val)-> console.log "THERE WAS FAILURE", val, child

addAssociation = (ev)->
  parent = parentEl()
  child  = ev.currentTarget
  $(child).addClass("highlightCell")
  parentId = periodId(parent)
  childId  = periodId(child)
  console.log "Add Assoc", parentId, childId, parent
  data =
    'child[parent_id]' : parentId
    'child_id'         : childId
  updateServer(data, parent, child)

removeAssociation = (ev)->
  parent = parentEl()
  child  = ev.currentTarget
  $(child).removeClass("highlightCell")
  console.log "Remove Assoc", parent
  data =
    'child[parent_id]' : ''
    'child_id'         : periodId(child)
  updateServer(data, parent, child)

parentEl = -> $('.parentCell.highlightCell')[0]
periodId = (el)-> el.id.split('_')[0]

disableClicks = ->
  $(".parentCell").removeClass("highlightCell")
  $('.childCell').removeClass("highlightCell")
  $('.clickableChild').unbind('click')
  $('.childCell').removeClass('clickableChild')

clickParent = (ev)->
  console.log "parent was clicked"
  ev.stopPropagation()
  clickedCurrentCell = $(ev.currentTarget).hasClass("highlightCell")
  disableClicks()
  unless clickedCurrentCell
    resetHighlights(ev.currentTarget)

resetHighlights = (parent)->
  $('.clickableChild').unbind('click')
  posn = $(parent).data('posn')
  $("span[data-posn='#{posn}']").addClass("highlightCell")
  $('.childCell').addClass('clickableChild')
  $('.clickableChild').click (ev)-> clickChild(ev)

clickChild = (ev)->
  ev.stopPropagation()
  if $(ev.currentTarget).hasClass('highlightCell')
    removeAssociation(ev)
  else
    addAssociation(ev)

$(document).ready ->
  console.log "loading"
  $('.parentCell').click (ev)-> clickParent(ev)
  $(document).click ->
    disableClicks()
