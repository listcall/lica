$(document).ready ->
  $('.updateName').editable
    type: "text"
    ajaxOptions:
      type: 'put'
  $('.updateAcronym').editable
    type: "text"
    ajaxOptions:
      type: 'put'
    success: -> location.reload()
  $('.updateTime').editable
    type: "text"
    ajaxToptions:
      type: 'put'

