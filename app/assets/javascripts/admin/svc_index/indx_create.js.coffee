$(document).ready ->
  $('#svcCreateBtn').click ->
    $('#svcModal').modal()
    $('#svcName').focus()
  $('#svcSaveBtn').click   ->
    if $('#svcName').val() == ''
      alert('Service must have a name...')
    else
      $('#svcCreateForm').submit()

