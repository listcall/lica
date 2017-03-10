$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#eventTypeBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/event_types/sort"
        type: 'post'
        data: $('#eventTypeBody').sortable("serialize",{expression:(/(.+)_(.+)/)})
        dataType: 'script'
  $('#eventTypeBody').disableSelection()

