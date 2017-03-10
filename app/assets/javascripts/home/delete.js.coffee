updateServer = (id)->
  targetUrl = "/home/#{window.memId}"
  $.ajax
    url: targetUrl
    type: 'delete'
    data: {widget: id}
    success: -> location.reload()

$(document).ready ->
  $('.fa-times').click (ev)->
    tgt = $(ev.target)
    panel = $(tgt).parents('.panel')
    $(panel).css('background', '#ff8080')
    pid = $(panel).attr('id')
    console.log "close was clicked", panel, pid
    updateServer(pid)