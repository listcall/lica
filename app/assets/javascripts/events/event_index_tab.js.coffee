$(document).ready ->
  $('#eventIdxTabs a:first').tab('show')

$(document).ready ->
  $('#eventIdxTabs a').click (ev)->
    ev.preventDefault()
    $(this).tab('show')
