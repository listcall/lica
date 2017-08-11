require("./new_send_button")

setSelectCount = -> $("#selectCount").text(memberCount())

window.updateSelectCount = ->
  setSelectCount()
  $("#memCount").effect("highlight", {}, 1000)
  setLabelCount()

window.setLabelCount = ->
  $el = $('#labelCount')
  mc = memberCount()
  pc = partnerCount()
  memStr = if mc > 1 then "members" else "member"
  memLbl = if mc == 0  then "" else "#{mc} #{memStr}"
  intStr = if mc!= 0 || pc != 0 then " to " else ""
  conStr = if mc!= 0 && pc != 0 then " and " else ""
  prtStr = if pc > 1 then "partners" else "partner"
  prtLbl = if pc == 0 then "" else "#{pc} #{prtStr}"
  $el.text("#{intStr}#{prtLbl}#{conStr}#{memLbl}")
  $('#sendLabel').effect("highlight", {}, 1000)
  updateSendButton()

selectAll = ->
  if ($('#selectAll').prop('checked'))
    $('.checkBox:visible:not(:checked)').each ->
      $(this).prop('checked', true)
      $('table').trigger('updateCell', [$(this).closest('td')[0], false])
    $('#selectAll').prop('title', "clear all visible members")
  else
    $('.checkBox:visible:checked').each ->
      $(this).prop('checked', false)
      $('table').trigger('updateCell', [$(this).closest('td')[0], false])
    $('#selectAll').prop('title', "select all visible members")
  updateSelectCount()
  $('#selectAll').blur()

$(document).ready ->
  setSelectCount()
  $('#selectAll').change selectAll
  $('.checkBox').click  updateSelectCount
  $('#selectAll').tooltip()
  $('#selectAll').prop('title', "select all visible members")
