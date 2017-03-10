setRights = (type, val)->
  console.log "setRights", type, val
  $.ajax
    url:  "/admin/member_roles/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "rights"
      value: val
    success: ->
      console.log "Rights Success"
    failure: ->
      console.log "Rights Failure"
#
#$(document).ready ->
#  $('.selectRights').on 'switch-change', (e, data)->
#    value = data.value
#    type  = e.target.id.split('_')[0]
#    setRights(type, value)



# note this ajax call relies on the CSRF token
# being set in show_ajax.js.coffee...
#updateServer = (val)->
#  $.ajax
#    url: "/ajax/members/#{lclData.member.id}"
#    type: 'put'
#    data: {name: 'time_button', value: val}

#updateMemberTimeSettings = (val)->
#  updateServer(val)

#switchChanged = (e)->
#  val = $('#pubChx').is(":checked")
#  updateServer(val)

#el_exists = (selector)->
#  $(selector).length != 0

$(document).ready ->
  console.log "loading buttons"
  $('.rightsGrp').button()
  $('.rightsBtn').change (ev)->
    console.log "something has changed", ev
    value = ev.target.id.split('_')[0]
    type  = ev.target.id.split('_')[1]
    setRights(type, value)

#    newState = ev.target.id
#    return unless $("##{newState}").is(':checked')
#    lclData.member.time_button = newState
#    updateCellVisibility(newState)
#    updateMemberTimeSettings(newState)
#  $("##{lclData.member.time_button}").click()
