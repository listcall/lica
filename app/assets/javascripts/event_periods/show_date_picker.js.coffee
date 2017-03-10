
window.initDatePicker = ->
  $('.parDateInput').unbind('date_time_picker').unbind('change')
  $('.parDateInput').date_time_picker
    changeMonth        : true
    changeYear         : true
    dateFormat         : "yy-mm-dd"
    showMonthAfterYear : true
    stepMinute         : 5
    minDate            : "-2Y"
    maxDate            : "+2M"
    onClose            : handlePickerClose

window.setupClearButton = ->
  $('.parDateClear').tooltip('destroy')
  $('.parDateClear').tooltip({title: "remove date"})
  $('.parDateClear').unbind('click')
  $('.parDateClear').click (ev)->
    console.log "clearCell was clicked!!", ev
    id = ev.target.id.split('.')[1]
    processChange('', id)

window.setupNowButton = ->
  $('.transitAction').tooltip('destroy')
  $('.transitAction').tooltip({title: "set to NOW"})
  $('.transitAction').unbind('click')
  $('.transitAction').click (ev)->
    id = ev.currentTarget.id.split('.')[1]
    processChange(currentTime(), id)

window.setupCopyButton = ->
  $('.signinAction').tooltip('destroy')
  $('.signed_in .signinAction').tooltip({title: "set all SignedIn times"})
  $('.signed_out .signinAction').tooltip({title: "set all SignedOut times"})
  $('.signinAction').unbind('click')
  $('.signinAction').click (ev)->
    id   = ev.currentTarget.id.split('.')[1]
    act  = id.split('-')[0]
    val  = $("##{id}").val()
    if confirm "all #{act} dates will be set to '#{val}' - are you sure?"
      $(".#{act} .parDateInput").each (idx, ele)->
        processChange(val, ele.id)

currentTime = ->
  cur = new Date();
  year = cur.getFullYear()
  month = cur.getMonth() + 1
  day   = cur.getDate()
  hour  = cur.getHours()
  min   = cur.getMinutes()
  "#{year}-#{month}-#{day} #{hour}:#{min}"

processChange = (val, cellId)->
  [field, parId] = cellId.split('-')
  console.log "fp", field, parId
  fname = "#{field}_at"
  $.ajax
    url:  "/ajax/event_periods/#{lclData.period.id}/event_participants/#{parId}"
    data: {name: fname, value: val}
    type: 'put'
    error:   -> console.log "there was error"
    success: (data)->
      console.log "there was success", parId
      $("#row_#{parId}").replaceWith(data)
      updateCellVisibility()
      initDatePicker()
      setupDeleteButton()
      setupClearButton()
      setupNowButton()
      setupCopyButton()
      setupRoleButton()

handlePickerClose = (data, obj)->

  newVal = data
  oldVal = $("##{obj.id}").data('current')
  inpId  = obj.id
  console.log "Picker Has Closed", newVal, oldVal, inpId
  if newVal == oldVal
    return
  processChange(newVal, inpId)

$(document).ready ->
  setupClearButton()
  setupNowButton()
  setupCopyButton()
  initDatePicker()