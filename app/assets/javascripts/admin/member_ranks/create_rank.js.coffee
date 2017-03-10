$(document).ready ->
  $('#rankCreateBtn').click (ev) ->
    ev.preventDefault()
    $('#createRankForm').submit()