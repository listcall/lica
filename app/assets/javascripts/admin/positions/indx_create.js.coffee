createPosition = (role_id)->
  console.log "CREATING POS", role_id
  $.ajax
    type: 'post'
    data: {team_role_id: role_id}
    url:  "/admin/position_index"
    success: -> location.reload()

processForm = (event)->
  el = event.target
  acro = $(el).data('role_id')
  createPosition(acro)

$(document).ready ->
  $('.createPos').click processForm