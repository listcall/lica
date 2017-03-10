$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#certTypeBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/qual_ctypes/sort"
        type: 'post'
        data: $('#certTypeBody').sortable("serialize",{expression:(/(.+)_(.+)/)})
        dataType: 'script'
#        error:   -> reloadHeaderNav()
  $('#certTypeBody').disableSelection()

