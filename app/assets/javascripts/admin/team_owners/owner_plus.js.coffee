toggleAjax = (id, hCls)->
  val = if hCls then "false" else "true"
  $.ajax
    method: "put"
    url:    "/admin/team_owners/#{id}"
    data:   {owner_plus: val}
  console.log "sending ajax", id, val

updateCell = ($el, hCls)->
  if hCls
    $el.removeClass('hlg')
  else
    $el.addClass('hlg')

toggleCell = (ev)->
  ev.preventDefault()
  $el = $(ev.target)
  id  = $el.attr('id').split('_')[1]
  hCls = $el.hasClass('hlg')
  updateCell($el, hCls)
  toggleAjax(id, hCls)

$(document).ready ->
  $('.ocell').click toggleCell

