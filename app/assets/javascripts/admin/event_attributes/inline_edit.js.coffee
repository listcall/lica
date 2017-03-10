$(document).ready ->
  $('.inlineEd').editable()
  $('.labelEd').editable
    success: -> location.reload()
