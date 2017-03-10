setRequiredCert = (type, val)->
  $.ajax
    url:  "/admin/quals/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "required"
      value: val

$(document).ready ->
  $('.requireToggle').on 'switch-change', (e, data)->
    value = data.value
    type  = e.target.id.split('_')[1]
    setRequiredCert(type, value)