window.LC = {}

$('document').ready ->
  $('#followupBtn').click -> $('#followupModal').modal()
  $('#cancelBtn').click   -> $('#followupModal').modal('hide')
  $('#sendBtn').click     -> console.log "SEND"
