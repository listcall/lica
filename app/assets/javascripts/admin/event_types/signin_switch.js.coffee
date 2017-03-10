setSignin = (type, val)->
  $.ajax
    url:  "/admin/event_types/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "use_signin"
      value: val

$(document).ready ->
  $('.signinToggle').on 'switch-change', (e, data)->
    value = data.value
    type  = e.target.id.split('_')[1]
    setSignin(type, value)