window.LC = {}

submitSendForm = (ev)->
  ev.preventDefault()
  console.log "Sending Followup"
  data = new FormData($('#sendForm')[0])
  console.log
  $.ajax
    url  : "/ajax/memberships/#{window.memberName}/certs"
    type : 'post'
    processData: false
    contentType: false
    data : data
    success: (data)->
      location.reload()
    error: (data)->
      loadCreateForm(data.responseText)

$('document').ready ->
  $('#followupBtn').click -> $('#followupModal').modal()
  $('#cancelBtn').click   -> $('#followupModal').modal('hide')
  $('#sendBtn').click     -> submitSendForm
