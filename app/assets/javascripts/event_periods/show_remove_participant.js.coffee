deleteParticipant = (id)->
  $.ajax
    type: "delete"
    url:  "/ajax/event_periods/#{lclData.period.id}/event_participants/#{id}"
    success: ->
      console.log "there was success removing the item"
      $("#row_#{id}").remove()
    failure: -> console.log "there was failure removing the item"

window.setupDeleteButton = ->
  $('.parDel').tooltip('destroy')
  $('.parDel').tooltip({title: "remove participant", placement: "left"})
  $('.parDel').unbind('click')
  $('.parDel').click (ev)->
    id = ev.target.id.split('_')[1]
    console.log "deleting", id
    deleteParticipant(id)

$(document).ready ->
  setupDeleteButton()
