$.fn.editable.defaults.mode        = "popup"
$.fn.editable.defaults.send        = "always"
$.fn.editable.defaults.placement   = "bottom"
$.fn.editable.defaults.ajaxOptions = {type: 'put'}

baseUrl = "/admin/svc_reps"

sendUpdate = (params)->
  $.ajax
    type: 'put'
    data: {name: params.name, value: params.value}
    url : "#{baseUrl}/#{params.pk}"

$(document).ready ->
  $('.nameEdit').editable({url: sendUpdate})
  $('.dateEdit').editable({url: sendUpdate, success: -> location.reload() })
  $('.svcEdit').editable({url: sendUpdate})
  $('.color').change ->
    $el = $('#cPick')
    opts =
      pk   : casePk
      name : 'label_color'
      value: $el.val()
    $.ajax
      url   : "#{caseUrl}/#{params.pk}"
      data  : opts
      method: 'put'
      success: -> 'color update worked'
      failure: -> 'color update failed'

