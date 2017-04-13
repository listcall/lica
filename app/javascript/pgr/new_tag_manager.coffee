#= require ./new_check_box
#= require ./new_send_button

typeAheadInit = ->
  $('#partnerTagInput').typeahead
    local    : lclData.selectList
    engine   : Hogan
    limit    : 15
    template : "<img src='{{team_icon}}' class='icon'/> {{value}}"

addTag = (ev, data)->
  htm = """
    <button data-title='click to remove' class='tagCell' id='#{data.tag_id}'>
      <img style='padding-top: 1px;' src="#{data.team_icon}" class='icon'/>
      #{data.value}
    </button>
  """
  $('.twitter-typeahead').before(htm) unless $("#" + "#{data.tag_id}").length > 0
  $("#" + "#{data.tag_id}").effect("highlight", {}, 1000)
  setLabelCount()
  updatePartnerTagValues()
  $('.tagCell').tooltip('destroy').tooltip()
  $('#clearPart').show()
  $('.tagCell').unbind('click').click (ev)=>
    $('.tagCell').tooltip('destroy')
    $(ev.target).remove()
    $('.tagCell').tooltip()
    setLabelCount()
    updatePartnerTagValues()
    $('#clearPart').hide() if $('.tagCell').length == 0

resetTypeAhead = ->
  $el = $('#partnerTagInput')
  $el.val('')
  $el.typeahead('destroy')
  typeAheadInit()
  $el.focus()

showPartners = ->
  $('#partnerTags').show()
  $('#showPart').hide()
  $('#partnerTagInput').focus()

hidePartners = ->
  $('#partnerTags').hide()
  $('#showPart').show()

updatePartnerTagValues = ->
  str = $('.tagCell').map(-> this.id).get().join()
  $('#partnerTagValue').val(str)

clearAllPartners = ->
  $('.tagCell').remove()
  setLabelCount()
  updatePartnerTagValues()
  $('#clearPart').blur().hide()

$(document).ready ->
  $("#showPart").click  showPartners
  $("#hidePart").click  hidePartners
  $("#clearPart").click clearAllPartners
  typeAheadInit()
  $('#partnerTagInput').on 'typeahead:selected', (ev, data)->
    addTag(ev, data)
    resetTypeAhead()