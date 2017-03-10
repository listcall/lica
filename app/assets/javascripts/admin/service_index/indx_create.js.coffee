# old_serv

$(document).ready ->
  $('#svcCreateBtn').click ->
    $('#svcModal').modal()
    $('#svcNameFld').focus()
  $('#svcSaveBtn').click   ->
    if $('#svcNameFld').val() == ''
      alert('Service must have a name...')
    else
      $('#svcCreateFrm').submit()

  $('#typCreateBtn').click ->
    $('#typModal').modal()
    $('#typNameFld').focus()
  $('#typSaveBtn').click   ->
    if $('#typNameFld').val() == ''
      alert('type must have a name...')
    else
      $('#typCreateFrm').submit()
