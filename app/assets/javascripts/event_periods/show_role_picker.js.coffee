# note this ajax call relies on the CSRF token
# being set in show_ajax.js.coffee...

window.setupRoleButton = ->
  $('.roleButton').tooltip('destroy')
  $('.roleButton').tooltip({title: "update event role", placement: "right"})
  $('.roleButton').editable
    type: "select"
    placement: "bottom"
    source: lclData.team.event_roles
    emptytext: "<i style='color: black;' class='fa fa-plus-circle'></i>"
    ajaxOptions:
      type: 'put'
      error:   -> console.log "there was error"
      success: (data)->
        $('#participantTable').html(data)
        updateCellVisibility()
        initDatePicker()
        setupDeleteButton()
        setupClearButton()
        setupNowButton()
        setupCopyButton()
        setupRoleButton()

$(document).ready ->
  setupRoleButton()
