postData = (el)->
  targetUrl = "/home"
  data = {type: el, id: window.memId}
  $.ajax
    data: data
    type: "post"
    url:  targetUrl
    success: -> location.reload()

$(document).ready ->
  $('.btnToggle').click (ev)->
    $('#addBtn').toggle()
    $('#addButtons').toggle()
  $('.btnClk').click (ev)->
    tgt = $(ev.target)
    el  = $(tgt).data('el')
    postData(el)
