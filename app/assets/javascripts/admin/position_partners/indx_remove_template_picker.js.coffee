# new_serv

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

removePicker = (pickerId)->
  $.ajax
    url:    "service_reps_pickers/#{pickerId}"
    method: "delete"
    success: ->
      $("#template_#{pickerId}").remove()

$(document).ready ->
  $('.remBtn').click (ev)->
    ev.preventDefault()
    $tgt = $(ev.target)
    pickerId = $tgt.data('pid')
    removePicker(pickerId)



