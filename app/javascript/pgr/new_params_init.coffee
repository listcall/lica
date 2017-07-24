checkMembers = (memList) ->
  if memList == "ALL"
    $(".checkBox").prop('checked', true)
  else
    _.each memList, (id) ->
      $("#broadcast_member_recipients_#{id}").prop('checked', true)

setAction = (data) ->
  if data.action_type == "NOTIFY"
    return
  action = switch data.action_type
    when "RSVP" then "RSVP"
    when "HEADS_UP" then "Heads Up"
    when "IMMEDIATE_CALLOUT" then "Immediate Callout"
    when "DELAYED_CALLOUT" then "Delayed Callout"
    when "LEAVE" then "Left Home"
    when "RETURN" then "Returned Home"
  console.log data.action_type
  console.log data.action
  LC.ra.optionSelect(action)
  LC.ra.periodSelect(data.action_opid)
  LC.ra.modalSave()

initSetup = (data)->
  $('#txtShort').val(data.short_text)
  checkMembers(data.recip_ids)
  setAction(data)
  updateSelectCount()

$(document).ready ->
  newParams = JSON.parse(lclData.newParams)
  unless _.isEmpty?(newParams)
    initSetup(newParams)
