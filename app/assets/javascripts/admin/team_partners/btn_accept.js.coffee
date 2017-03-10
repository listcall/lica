acceptHandler = (data)->
  partner_id = data.target.id.split('_')[1]
  console.log "RUNNING ACCEPT HANDLER", partner_id
  $.ajax
    url:  "/admin/team_partners/#{partner_id}"
    type: "PUT"
    success: ->
      location.reload()
    error:   (data)->
      console.log "THERE WAS ERROR", data

$(document).ready ->
  $('.btnAccept').click (data)-> acceptHandler(data)

