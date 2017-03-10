addPartner = (partner_team_id)->
  $.ajax
    url:  "/admin/team_partners"
    type: "POST"
    data: {partner_id: partner_team_id}
    success: -> location.reload()
    error:   (data)-> console.log "THERE WAS ERROR", data

typeaheadInit = ($el)->
  $el.typeahead
    local:  lclData.partnerList
    engine: Hogan
    template: "{{value}}"

resetTypeAhead = ->
  $el = $('#addPartner')
  $el.val('')
  $el.typeahead('destroy')
  typeaheadInit($el)
  $el.focus()

$(document).ready =>
  resetTypeAhead()
  $('#addPartner').on 'typeahead:selected', (ev, data)=>
    addPartner(data.team_id)
    resetTypeAhead()
