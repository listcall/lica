memberCount  = -> $('.rChk:checked').length

updateSelectCount = ->
  $("#selectCount").text(memberCount())
  $("#selectCount").effect("highlight", {}, 1000)

readyToSend = ->
  textLen  = $('#txtShort').val()?.length || 0
  return false unless textLen > 0
  return false unless $('#emailCheck')[0].checked || $('#smsCheck')[0].checked
  return false unless memberCount() > 0
  true

updateSendButton = ->
  if readyToSend()
    $('#sendBtn').prop('disabled', false).html("Send")
  else
    $('#sendBtn').prop('disabled', true).html("<del>Send</del>")

$(document).ready ->
  updateSendButton()
  $('.rChk').change       updateSelectCount
  $('.rChk').change       updateSendButton
  $('#emailCheck').change updateSendButton
  $('#smsCheck').change   updateSendButton
  $('#txtShort').keyup    updateSendButton
