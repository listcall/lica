deletePeriod = (id)->
  console.log "DELETING ID IS", id
  $.ajax
    method: "delete"
    url: "/services/#{lclData.serviceId}/avail/#{lclData.memberName}?avail_id=#{id}"
    success: (data)->
      console.log "there was success deleting the item", data
      location.reload()
    failure: -> console.log "FAILURE"

$(document).ready ->
  $('.delBtn').click (ev)->
    console.log "EV IS", ev
    id = $(ev.target).data('pid')
    deletePeriod(id)