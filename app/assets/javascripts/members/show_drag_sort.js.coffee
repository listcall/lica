makeSortable = (elementId, targetUrl)->
  $(elementId).sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  targetUrl
        type: 'post'
        data: $(elementId).sortable('serialize')
        dataType: 'script'
  $(elementId).disableSelection()

$(document).ready ->
  memberId = window.memId
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)
  makeSortable("#phoneBody",   "/ajax/memberships/#{memberId}/phones/sort")
  makeSortable("#emailBody",   "/ajax/memberships/#{memberId}/emails/sort")
  makeSortable("#addressBody", "/ajax/memberships/#{memberId}/addresses/sort")
  makeSortable("#contactBody", "/ajax/memberships/#{memberId}/contacts/sort")
