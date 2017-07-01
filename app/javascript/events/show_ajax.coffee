window.doAjax = (data)->
  $.ajax
    url: "/ajax/events/#{lclData.eventId}"
    type: 'put'
    data: data
    success: (ev, data)->
      if ev != lclData.eventRef
        window.location.replace("/events/#{ev}")

$(document).ready ->
  $(document).ajaxSend (e, xhr, options)->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)
