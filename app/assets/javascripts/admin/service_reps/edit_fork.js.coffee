# old_serv

baseUrl = "/admin/service_reps/#{lclData.reportId}"

setFork = (val)->
  $.ajax
    type: 'put'
    data: {name: 'fork', value: val}
    url : baseUrl
    success: -> location.reload()

processClick = (ev)->
  ev.preventDefault()
  $tgt = $(ev.target)
  if $tgt.hasClass('green')
    if confirm "All edits will be lost!  Are you sure?"
      setFork(false)
  else
    setFork(true)

$(document).ready ->
  $('.tmplFork').click processClick