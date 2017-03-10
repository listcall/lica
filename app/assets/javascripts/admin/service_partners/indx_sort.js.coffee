# old_serv

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#serviceBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    dropOnEmpty: true,
    update: ->
      $.ajax
        url:  "/admin/service_partners/sort"
        type: 'post'
        data: $('#serviceBody').sortable('serialize')
        dataType: 'script'
  $('#serviceBody').disableSelection()



