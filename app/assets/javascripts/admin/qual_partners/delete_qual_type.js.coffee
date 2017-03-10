$(document).ready ->
  $('.btnDelete').click (ev) ->
    ev.preventDefault()
    typeid = $(this).data('typeid')
    $("#form_#{navid}").submit()

