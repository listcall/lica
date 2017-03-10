genData = (ev)->
  tgt    = ev.target
  provId = tgt.id.split('_')[1]
  $row   = $("#row_#{provId}")
  start  = $row.find(".start").html()
  finis  = $row.find(".finis").html()
  [provId, start, finis]

doAjax = (data, status)->
  [provId, start, finis] = data
  opts = {status : status}
  if status == "accept"
    opts.start  = start
    opts.finish = finis
  $.ajax
    url    : "/services/na/hours/#{provId}"
    data   : opts
    method : 'put'
#    failure: -> console.log "THERE WAS FAILURE"
    success: ->
      $("#row_#{provId}").remove()

acceptClick = (ev)->
  ev.preventDefault()
  doAjax(genData(ev), "accept")
  console.log "ACCEPT WAS CLICKED"

rejectClick = (ev)->
  ev.preventDefault()
  doAjax(genData(ev), "reject")
  console.log "REJECT WAS CLICKED"

$(document).ready ->
  $('.acceptBtn').click acceptClick
  $('.rejectBtn').click rejectClick