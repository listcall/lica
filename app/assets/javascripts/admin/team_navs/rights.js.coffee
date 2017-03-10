#= require ./reload_nav

updateServer = (id, typ, action, pk)->
  $.ajax
    url:    "/admin/team_navs/#{id}"
    method: "POST"
    data:   {name: typ, value: action, pk: pk}
    success: -> ADM.reloadNav()
    error:   -> ADM.reloadNav()

setClick = (selector)=>
  $(selector).click (ev)->
    ev.preventDefault()
    target = ev.target
    id = $(target).data('nid')
    tp = $(target).data('btyp')
    ty = $(target).data('typ')
    current_status = $(target).data('status')
    new_status     = if current_status == "show" then "hide" else "show"
    $(target).data('status', new_status)
    updateServer(id, tp, new_status, ty)
    if new_status == "show"
      $(target).removeClass('btn-warning').addClass('btn-success')
    else
      $(target).removeClass('btn-success').addClass('btn-warning')

$(document).ready ->
  setClick('.btnRights')

