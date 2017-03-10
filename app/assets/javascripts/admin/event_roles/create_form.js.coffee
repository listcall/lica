$(document).ready ->
  $('#addButton').click (ev) ->
    ev.preventDefault()
    $('#addButton').hide()
    $('#createForm').show()
  $('#cancelButton').click (ev) ->
    ev.preventDefault()
    $('#addButton').show()
    $('#createForm').hide()

