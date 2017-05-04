initSetup = (data)->
  $('#txtShort').val(data.short_text)
  _.each data.recip_ids, (id) ->
    $("#broadcast_member_recipients_#{id}").prop('checked', true)
  LC.ra.optionSelect("RSVP")
  LC.ra.periodSelect(data.action_opid)
  LC.ra.modalSave()
  updateSelectCount()

$(document).ready ->
  newParams = JSON.parse(lclData.newParams)
  unless _.isEmpty?(newParams)
    initSetup(newParams)
