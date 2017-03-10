$(document).ready ->
  $('#wikiCreateBtn').click -> $('#myModal').modal()
  $('#wikiSaveBtn').click   -> $('#wikiCreateForm').submit()