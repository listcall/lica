# ----- initialization -----

opts =
  format:    "yyyy-mm-dd"
  endDate:   "+2y"
  startDate: "-2y"
  inputs:    [$('#startDate'), $('#finishDate')]
  autoclose: true
  todayHighlight: true
  orientation: 'top'
  todayBtn: "linked"

$(document).ready ->
  console.log "DATEPICKER SETUP"
  $('#attrTable').datepicker(opts)

# ----- event handleing -----

prepAjax = ->
  startDate  = $('#startDate').val()
  startTime  = $('#startTime').editable('getValue').start_time
  finishDate = $('#finishDate').val()
  finishTime = $('#finishTime').editable('getValue').finish_time
  allDay     = $('#dayChx').is(':checked')
  opts = {"event[start_date]" : startDate, "event[finish_date]" : finishDate}
  if allDay == false && "#{startDate} #{startTime}" > "#{finishDate} #{finishTime}"
    opts["event[finish_time]"] =  "23:59"
    $('#finishTime').editable('setValue', "23:59", false)
    $('#finishTime').addClass('editable-unsaved')
  doAjax(opts)
  highlightChangedDates(startDate, finishDate)
  rememberDateValues()

highlightChangedDates = (startDate, finishDate)->
  if startDate != window.oldStart
    $('#startDate').addClass('editable-unsaved')
  if finishDate != window.oldFinish
    $('#finishDate').addClass('editable-unsaved')

rememberDateValues = ->
  window.oldStart  = $('#startDate').val()
  window.oldFinish = $('#finishDate').val()

$(document).ready ->

  rememberDateValues()
  $('#attrTable').datepicker().on 'changeDate', (e)->
    prepAjax()