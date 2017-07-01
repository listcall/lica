doAjax = (memberId, roleAcronym)->
  $.ajax
    method : 'put'
    url    : "/positions/#{memberId}"
    data   : {name: "take_role", value: roleAcronym}
    success: -> location.reload()

$(document).ready ->
  $('.becomeLnk').click (el)->
    console.log "EL IS", el
    $el = $(el.target)
    role = $el.data('role')
    memId = $el.data('mid')
    $('.lbl').text(role)
    $('#becomeBtn').text("Become #{role}")
    $('#becomeBtn').unbind().click -> doAjax(memId, role)
    $('#myModal').modal()