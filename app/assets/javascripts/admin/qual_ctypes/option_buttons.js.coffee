updateServer = (id, name, val)->
  console.log "updating with", id, name, val
  $.ajax
    url: "/admin/qual_ctypes/#{id}"
    type: 'put'
    data:
      pk: id
      name: name
      value: val

$(document).ready ->

  $('.comCk').tooltip({placement: 'top'})
  $('.expCk').tooltip({placement: 'top'})

  $('.comChk').change (ev)->
    $tgt  = $(ev.target)
    id    = $tgt.attr('id').split('_')[1]
    value = if $tgt.parent().hasClass('active') then 0 else 1
    updateServer(id, "commentable", value)

  $('.expChk').change (ev)->
    $tgt  = $(ev.target)
    id    = $tgt.attr('id').split('_')[1]
    value = if $tgt.parent().hasClass('active') then 0 else 1
    updateServer(id, "expirable", value)
