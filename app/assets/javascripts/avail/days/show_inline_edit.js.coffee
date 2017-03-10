$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.placement = "bottom"
$.fn.editable.defaults.url       = "/avail/days/#{lclData.memberName}"

$(document).ready ->

  $('.textEditable').editable
    inputclass  : 'textInput'
    type        : 'text'
    ajaxOptions :
      type: 'put'
