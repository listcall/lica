makeSortable = (elementId)->
  targetUrl = "/home/#{window.memId}/sort"
  $(elementId).sortable
    connectWith: '.widgetList'
    opacity: 0.4
    handle:  '.fa-arrows'
    update: (ev)->
      tgt  = $(ev.target)
      col  = $(tgt).attr('id')
      list = $(tgt).sortable('serialize')
      data = {col: col, list: list}
      $.ajax
        url:  targetUrl
        type: 'post'
        data: data
        dataType: 'script'
  $(elementId).disableSelection()

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)
  makeSortable("#col1, #col2")