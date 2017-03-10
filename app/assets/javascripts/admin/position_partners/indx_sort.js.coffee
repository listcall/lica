# new_serv

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#positionBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    dropOnEmpty: true,
    update: ->
      $.ajax
        url:  "/admin/position_partners/sort"
        type: 'post'
        data: $('#positionBody').sortable('serialize')
        dataType: 'script'
  $('#positionBody').disableSelection()



