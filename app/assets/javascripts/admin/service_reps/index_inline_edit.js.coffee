# old_serv

$.fn.editable.defaults.mode        = "popup"
$.fn.editable.defaults.send        = "always"
$.fn.editable.defaults.placement   = "bottom"
$.fn.editable.defaults.ajaxOptions = {type: 'put'}

baseUrl = "/admin/service_reps"

sendUpdate = (params)->
  $.ajax
    type: 'put'
    data: {name: params.name, value: params.value}
    url : "#{baseUrl}/#{params.pk}"

$(document).ready ->
  $('.nameEdit').editable({url: sendUpdate})
  $('.svcEdit').editable({url: sendUpdate})

