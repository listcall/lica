checkMembers = (memList) ->
  if memList == "ALL"
    $(".checkBox").prop('checked', true)
  else
    _.each memList, (id) ->
      $("#broadcast_member_recipients_#{id}").prop('checked', true)

setAction = (data) ->
  unless data.action_type == "RSVP"
    return
  LC.ra.optionSelect(data.action_type)
  LC.ra.periodSelect(data.action_opid)
  LC.ra.modalSave()

initSetup = (data)->
  $('#txtShort').val(data.short_text)
  checkMembers(data.recip_ids)
  setAction(data)
  updateSelectCount()

$(document).ready ->
  newParams = JSON.parse(lclData.newParams)
  console.log newParams
  unless _.isEmpty?(newParams)
    initSetup(newParams)
