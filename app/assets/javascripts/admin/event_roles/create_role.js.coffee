$(document).ready ->
  $('#roleCreateBtn').click (ev) ->
    ev.preventDefault()
    $('#createRoleForm').submit()