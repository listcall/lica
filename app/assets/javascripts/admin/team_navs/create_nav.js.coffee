$(document).ready ->
  $('#hdrCreateBtn').click (ev) ->
    ev.preventDefault()
    $('#createHdrNavForm').submit()
  $('#ftrCreateBtn').click (ev) ->
    ev.preventDefault()
    $('#createFtrNavForm').submit()
  $('#homeCreateBtn').click (ev) ->
    ev.preventDefault()
    $('#createHomeNavForm').submit()
