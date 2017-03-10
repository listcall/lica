$(document).ready ->
  $('.inline').editable
    success: -> location.reload()
