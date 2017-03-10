
$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#forumBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    dropOnEmpty: true,
    update: ->
      $.ajax
        url:  "/admin/forum_index/sort"
        type: 'post'
        data: $('#forumBody').sortable('serialize')
        dataType: 'script'
  $('#forumBody').disableSelection()



