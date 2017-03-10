$(document).ready ->
  $('#driveCreateBtn').click -> $('#myModal').modal()
  $('#driveSaveBtn').click   -> $('#driveCreateForm').submit()