setTransit = (type, val)->
  $.ajax
    url:  "/admin/event_types/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "use_transit"
      value: val

$(document).ready ->
  $('.transitToggle').on 'switch-change', (e, data)->
    value = data.value
    type  = e.target.id.split('_')[1]
    setTransit(type, value)