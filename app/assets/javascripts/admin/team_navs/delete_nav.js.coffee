$(document).ready ->
  $('.btnDelete').click (ev) ->
    ev.preventDefault()
    navid = $(this).data('navid')
    $("#form_#{navid}").submit()

