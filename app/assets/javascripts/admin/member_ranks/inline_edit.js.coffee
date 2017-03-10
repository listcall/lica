$(document).ready ->
  $('.inline').editable()
  $('.inlineLbl').editable
    success: -> location.reload()

