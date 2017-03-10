eventObj = ->
  key = $('#event_typ').val()
  obj = JSON.parse(lclData.eTypes)[key]

defaultStart = ->
  eventObj()['default_start_time']

defaultFinish = ->
  eventObj()['default_finish_time']

showTime = ->
  $('#startTime').val(defaultStart())
  $('#finishTime').val(defaultFinish())
  $('.time-width').show()

hideTime = ->
  $('.time-width').hide()
  $('.time-width').val('')

setTime = ->
  if $('#dayChx').is(':checked')
    hideTime()
  else
    showTime()

updateModal = (driveId, driveName)->
  console.log driveId, driveName
  $('#modal-title').html("Upload File for Drive: <b>#{driveName}</b>")
  $('#fileUploadForm').attr('action', "/drives/#{driveId}/files")
  $('#df_drive_id').val(driveId)
  $('#fileUploadBtn').click -> $('#fileUploadForm').submit()

$(document).ready ->
  $('#uploadBtn').click (ev)->
    ev.preventDefault()
    $tgt = $(ev.target)
    updateModal($tgt.data('driveid'), $tgt.data('drivename'))
    $('#myModal').modal()

