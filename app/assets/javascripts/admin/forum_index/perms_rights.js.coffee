updateServer = (pk, name, value)->
  console.log "updating server"
  $.ajax
    url:    "/admin/forum_index/#{pk}"
    method: "PUT"
    data:   {name: name, value: value, pk: pk}

setClick = (selector)=>
  $(selector).click (ev)->
    ev.preventDefault()
    target = ev.target
    pk     = $(target).data('forum_id')
    name   = $(target).data('name')
    current_status = if $(target).hasClass('btn-success') then "show" else "hide"
    new_status     = if current_status == "show" then "hide" else "show"
    updateServer(pk, name, new_status)
    if new_status == "show"
      $(target).removeClass('btn-warning').addClass('btn-success')
    else
      $(target).removeClass('btn-success').addClass('btn-warning')

$(document).ready ->
  setClick('.btnRights')
