# note this ajax call relies on the CSRF token
# being set in show_ajax.coffee...
updateServer = (val)->
  $.ajax
    url: "/ajax/members/#{lclData.member.id}"
    type: 'put'
    data: {name: 'time_button', value: val}

updateMemberTimeSettings = (val)->
  updateServer(val)

switchChanged = (e)->
  val = $('#pubChx').is(":checked")
  updateServer(val)

showNoneCells = ->
  $('.transitCell').hide()
  $('.signinCell').hide()

showTransitCells = ->
  if el_exists('#transit')
    $('.transitCell').show()
    $('.signinCell').hide()
  else
    showNoneCells()
    $('#none').click()

showSigninCells = ->
  if el_exists('#signin')
    $('.transitCell').hide()
    $('.signinCell').show()
  else
    showNoneCells()
    $('#none').click()

window.updateCellVisibility = (showState = lclData.member.time_button)->
  switch showState
    when "none"    then showNoneCells()
    when "transit" then showTransitCells()
    when "signin"  then showSigninCells()

el_exists = (selector)->
  $(selector).length != 0

$(document).ready ->
  $('#timeRadio').button()
  $('.timeBtn').change (ev)->
    newState = ev.target.id
    return unless $("#" + "#{newState}").is(':checked')
    lclData.member.time_button = newState
    updateCellVisibility(newState)
    updateMemberTimeSettings(newState)
  $("#" + "#{lclData.member.time_button}").click()
