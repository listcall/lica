window.update_link_for = (type)->
  link_id = "#{type}_link"
  start   = $("##{type}_start").val()
  finish  = $("##{type}_finish").val()
  $("##{link_id}").data('start', start).data('finish', finish)

$(document).ready ->
  $('.inp').keyup (ev)->
    console.log "input has changed!", ev, type
    type = ev.target.id.split('_')[0]
    update_link_for(type)

$(document).ready ->
  $('.hRep').click (ev)->
    tgt     = ev.target
    start   = $(tgt).data('start')
    startS  = if start == undefined then "" else "start=#{start}&"
    finish  = $(tgt).data('finish')
    finishS = if finish == undefined then "" else "finish=#{finish}&"
    typ     = $(tgt).data('type')
    vsn     = ev.target.id.split('_')[0].split('-')[0]
    newHref = "/hreports/#{vsn}.html?#{startS}#{finishS}type=#{typ}"
    $(tgt).attr('href', newHref)
