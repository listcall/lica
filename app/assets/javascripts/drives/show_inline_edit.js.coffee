$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.placement = "bottom"
$.fn.editable.defaults.url       = "/ajax/events/#{lclData.eventId}"
$.fn.editable.defaults.pk        = lclData.eventId

$(document).ready ->
  $('.textEditable').editable
    inputclass: 'textInput'
    ajaxOptions:
      type: 'put'
  $('.selectEditable').editable
    ajaxOptions:
      type: 'put'
      success: (ev, data)->
        console.log "successful!!", ev, data
        if ev != lclData.eventRef
          window.location.replace("/events/#{ev}")
    source: JSON.parse(lclData.eSelect)




