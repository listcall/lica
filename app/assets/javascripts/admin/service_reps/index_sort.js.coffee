# old_serv

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#reportBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/service_reps/sort"
        type: 'post'
        data: $('#reportBody').sortable('serialize')
        dataType: 'script'
  $('#reportBody').disableSelection()

