
$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#wikiBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    dropOnEmpty: true,
    update: ->
      $.ajax
        url:  "/admin/wiki_index/sort"
        type: 'post'
        data: $('#wikiBody').sortable('serialize')
        dataType: 'script'
  $('#wikiBody').disableSelection()



