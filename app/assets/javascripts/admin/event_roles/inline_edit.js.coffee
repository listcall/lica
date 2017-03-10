$(document).ready ->
  $('.editName').editable
    ajaxOptions:
      type: 'put'
  $('.editAcronym').editable
    ajaxOptions:
      type: 'put'
    success: -> location.reload()




