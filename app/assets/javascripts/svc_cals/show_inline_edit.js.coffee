$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.placement = "bottom"
$.fn.editable.defaults.url       = "/services/#{lclData.serviceId}/avail/#{lclData.memberName}"

$(document).ready ->

  $('.textEditable').editable
    inputclass  : 'textInput'
    type        : 'text'
    ajaxOptions :
      type: 'put'

#  $('.selectEditable').editable
#    type: 'select'
#    ajaxOptions:
#      type: 'put'
#      success: (ev, data)->
#        console.log "successful!!", ev, data
#
#  $('.checkEditable').editable
#    type: 'checklist'
#    source: lclData.partnerSrc
#    ajaxOptions:
#      type: 'put'