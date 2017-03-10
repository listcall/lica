setHas = (type, val)->
  ajax_val = if val == true then "one" else "many"
  $.ajax
    url:  "/admin/member_roles/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "has"
      value: ajax_val
    success: ->
      location.reload()
    failure: ->
      location.reload()

$(document).ready ->
  $('.selectHas').on 'switch-change', (e, data)->
    value = data.value
    type  = e.target.id.split('_')[0]
    setHas(type, value)