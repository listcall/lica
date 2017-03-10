
$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#attributeBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/member_attributes/sort"
        type: 'post'
        data: $('#attributeBody').sortable('serialize')
        dataType: 'script'
  $('#attributeBody').disableSelection()

