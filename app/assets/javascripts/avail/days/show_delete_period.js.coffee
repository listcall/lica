deletePeriod = (id)->
  $.ajax
    method: "delete"
    url: "/avail/days/#{lclData.memberName}?avail_id=#{id}"
    success: (_data)-> location.reload()
    failure: -> console.log "FAILURE"

$(document).ready ->
  $('.delBtn').click (ev)->
    id = $(ev.target).data('pid')
    deletePeriod(id)