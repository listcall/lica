opts =
  format:    "yyyy-mm-dd"
  endDate:   "+2y"
  startDate: "-2y"
  inputs:    [$('#startDate'), $('#finishDate')]
  todayBtn: "linked"
  autoclose: true
  todayHighlight: true

$(document).ready ->
  $('#dateRow').datepicker(opts)








