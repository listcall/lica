
setupSort = (target)->
  $("#" + target).sortable
    placeholder: 'ui-state-highlight'
    axis:        'y'
    items:       'tr'
    opacity:     0.4
    handle:      '.sortIcon'
    cursor:      'move'
    update: (e)->
      data = $(e.target).sortable('serialize')
      console.log "sorting", data
      $.ajax
        type: 'post'
        url:  "/ajax/memberships/#{memberName}/certs/sort"
        data: data
        dataType: 'script'
  $("#" + target).disableSelection()

$(document).ready ->
  $('.sortContainer').each (_idx, el)->
    tgt = $(el).attr('id')
    setupSort(tgt)
