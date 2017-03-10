$(document).ready ->
  $('#forumCreateBtn').click -> $('#myModal').modal()
  $('#forumSaveBtn').click   -> $('#forumCreateForm').submit()