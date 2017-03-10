$(document).ready ->
  $('#eventTypeCreateBtn').click -> $('#myModal').modal()
  $('#eventTypeSaveBtn').click   -> $('#eventTypeCreateForm').submit()