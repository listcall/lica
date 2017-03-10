window.addUser = (inputData)->
  $.ajax
    url:  "/ajax/event_periods/#{lclData.period.id}/event_participants"
    type: "POST"
    data: inputData
    success: (data)->
      $('#participantTable').html(data) if inputData.child == false
      $('#childTable').html(data) if inputData.child == true
      updateCellVisibility()
      initDatePicker()
      setupDeleteButton()
      setupClearButton()
      setupNowButton()
      setupCopyButton()
      setupRoleButton()
      $('#addUser').focus()
    error:   (data)-> console.log "THERE WAS ERROR", data

typeaheadInit = ->
  $('#addUser').typeahead
    local   : lclData.memlist
    engine  : Hogan
    limit   : 10
    template: "<img src='{{team_icon}}' class='icon'/> <img src='{{avatar}}' class='icon' /> {{value}}"

resetTypeAhead = ->
  $('#addUser').val('')
  $('#addUser').typeahead('destroy')
  typeaheadInit()

$(document).ready ->
  resetTypeAhead()
  $('#addUser').on 'typeahead:selected', (ev, data)->
    addUser(data)
    resetTypeAhead()

