$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.pk        = lclData.eventId

$(document).ready ->
  $('.addParent').editable
    type       : 'select'
    placement  : 'left'
    source     : lclData.parents
    ajaxOptions:
      type: 'post'
      url:  "/ajax/events/#{lclData.eventId}/event_parent"
      success: -> location.reload()
  $('.addChild').editable
    type       : 'select'
    placement  : 'left'
    source     : lclData.children
    ajaxOptions:
      type: 'post'
      url:  "/ajax/events/#{lclData.eventId}/event_children"
      success: -> location.reload()
  $('.delParent').click ->
    return unless confirm "Are you sure?"
    console.log "delete Parent was clicked!"
    $.ajax
      type: "delete"
      url : "/ajax/events/#{lclData.eventId}/event_parent"
      success: -> location.reload()
  $('.delChild').click (ev)->
#    return unless confirm "Are you sure?"
    evId = $(ev.target).data('evid')
    $.ajax
      type: "delete"
      url : "/ajax/events/#{evId}/event_parent"
      success: -> location.reload()
