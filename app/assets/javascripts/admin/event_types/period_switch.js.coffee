setPeriod = (type, val)->
  $.ajax
    url:  "/admin/event_types/#{type}"
    type: 'put'
    data:
      pk:    type
      name:  "max_periods"
      value: val

$(document).ready ->
  $('.periodToggle').on 'switch-change', (e, data)->
    value = if data.value then "one" else "many"
    type  = e.target.id.split('_')[1]
    setPeriod(type, value)