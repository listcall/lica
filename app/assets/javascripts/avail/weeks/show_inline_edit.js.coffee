$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.placement = "left"
$.fn.editable.defaults.url       = "/avail/weeks/#{lclData.memberName}"

$(document).ready ->

  $('.textEditable').editable
    inputclass  : 'textInput'
    type        : 'text'
    ajaxOptions :
      type: 'put'

  $('.selectEditable').editable
    type: 'select'
    source: ['', 'available', 'unavailable']
    ajaxOptions:
      type: 'put'
      success: (ev, data)->
        console.log "successful!!", ev, data

