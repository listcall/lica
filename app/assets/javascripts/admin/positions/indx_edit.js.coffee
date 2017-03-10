baseUrl = "/admin/positions"

sendUpdate = (params)->
  $.ajax
    type: 'put'
    data: {name: params.name, value: params.value}
    url : "#{baseUrl}/#{params.pk}"

$(document).ready ->

  $('.ptCk').editable({url: sendUpdate})

  $('.inline').editable
    ajaxOptions:
      type: 'put'




