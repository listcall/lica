$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#qualBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/quals/sort"
        type: 'post'
        data: $('#qualBody').sortable("serialize",{expression:(/(.+)_(.+)/)})
        dataType: 'script'
#        error:   -> reloadHeaderNav()
  $('#qualBody').disableSelection()
