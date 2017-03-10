#window.doAjax = (data)->
#  console.log "doing AJAX", data
#  $.ajax
#    url: "/ajax/events/#{eventId}"
#    type: 'put'
#    data: data

$(document).ready ->
  $(document).ajaxSend (e, xhr, options)->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)
