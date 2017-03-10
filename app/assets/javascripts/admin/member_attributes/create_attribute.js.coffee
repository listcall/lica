$(document).ready ->
  $('#attributeCreateBtn').click (ev) ->
    ev.preventDefault()
    $('#createAttributeForm').submit()