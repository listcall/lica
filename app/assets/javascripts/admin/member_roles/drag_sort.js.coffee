
$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#roleBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/member_roles/sort"
        type: 'post'
        data: $('#roleBody').sortable('serialize')
        dataType: 'script'
  $('#roleBody').disableSelection()

