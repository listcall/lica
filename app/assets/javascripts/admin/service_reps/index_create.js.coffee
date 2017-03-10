# old_serv

$(document).ready ->
  $('#reportCreateBtn').click -> $('#myModal').modal()
  $('#reportSaveBtn').click   ->
    if $('#reportName').val() == ''
      alert('Service must have a name...')
    else
      $('#reportCreateForm').submit()