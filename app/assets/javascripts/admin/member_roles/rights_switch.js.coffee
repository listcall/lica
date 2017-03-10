setRights = (type, val)->
  ajax_val = if val == true then "owner" else "active"
  console.log "something is up!", type, val, ajax_val
  $.ajax
    url:  "/admin/member_roles/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "rights"
      value: ajax_val
    success: ->
      console.log "Rights Success"
    failure: ->
      console.log "Rights Failure"

$(document).ready ->
  $('.selectRights').on 'switch-change', (e, data)->
    value = data.value
    type  = e.target.id.split('_')[0]
    setRights(type, value)