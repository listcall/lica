reloadPage = ->
  console.log "RELOADING PAGE"
  location.reload()

$(document).ready ->
  $('#periodBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    dropOnEmpty: true,
    update: ->
      $.ajax
        url:  "/events/#{lclData.eventId}/periods/sort"
        type: 'put'
        data: $('#periodBody').sortable('serialize')
        dataType: 'script'
        success: reloadPage
        error:   reloadPage
  $('#periodBody').disableSelection()
