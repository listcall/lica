$(document).ready ->
  $('#certBoardCreateBtn').click -> $('#myModal').modal()
  $('#certBoardSaveBtn').click   -> $('#certBoardCreateForm').submit()