setExpirableCert = (type, val)->
  $.ajax
    url:  "/admin/quals/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "expirable"
      value: val

$(document).ready ->
  $('.expirableToggle').on 'switch-change', (e, data)->
    value = data.value
    type  = e.target.id.split('_')[1]
    setExpirableCert(type, value)