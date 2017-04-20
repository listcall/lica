window.memberCount  = -> $('.checkBox:checked').length
window.partnerCount = -> $('.tagCell').length

readyToSend = ->
  longLen  = $('#txtLong').val()?.length || 0
  combiLen = $('#txtShort').val().length + longLen
  return false unless combiLen > 0
  return false unless $('#emailCheck')[0].checked || $('#smsCheck')[0].checked
  return false unless memberCount() > 0 || partnerCount() > 0
  true

window.updateSendButton = ->
  if readyToSend()
    $('#sendButton').prop('disabled', false).html("Send")
  else
    $('#sendButton').prop('disabled', true).html("<del>Send</del>")

$(document).ready ->
  updateSendButton()
  $('#emailCheck').change updateSendButton
  $('#smsCheck').change updateSendButton
  $('.pageTxt').keyup     updateSendButton
