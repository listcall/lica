pickerOpts =
  format:    "yyyy-mm-dd"
  startDate: "-1m"
  endDate:   "+4m"
  inputs:    [$('#createStart'), $('#createFinis')]
  autoclose: true
  todayHighlight: true
  orientation: 'top'
  todayBtn: "linked"

# ----- date picker for create form -----

$(document).ready ->
  $('#createForm').datepicker(pickerOpts)

# ----- date picker for update/change form -----

doAjax = (data)->
  $.ajax
    url: "/services/#{lclData.serviceId}/avail/#{lclData.memberName}"
    type: 'put'
    data: data
    success: (data)->
      $('#calCol').html(data)

prepAjax = (num)->
  startDate = $("#start_#{num}").val()
  finisDate = $("#finis_#{num}").val()
  opts = {"pk" : num, "cal[start]" : startDate, "cal[finish]" : finisDate}
  doAjax(opts)
  
setDatePicker = (element, row)->
  id = $(row).attr('id')
  num = id.split('_')[1]
  start = "#start_#{num}"
  finis = "#finis_#{num}"
  pickerOpts.inputs = [$(start), $(finis)]
  $("##{id}").datepicker(pickerOpts).on 'changeDate', -> prepAjax(num)

$(document).ready ->
  $('.availRow').each setDatePicker