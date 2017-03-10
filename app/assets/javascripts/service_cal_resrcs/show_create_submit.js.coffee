$(document).ready ->
  $('#createBtn').click (ev)->
    ev.preventDefault()
    start = $('#createStart').val()
    fin   = $('#createFinish').val()
    if start == "" || fin == ""
      alert "both Start and Finish must be filled in!!"
    else
      $('#createForm').submit()