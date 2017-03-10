$(document).ready ->
  $('#certTypeCreateBtn').click -> $('#myModal').modal()
  $('#certTypeSaveBtn').click   -> $('#certTypeCreateForm').submit()