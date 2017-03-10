typeAheadInit = ->
  $el = $('#memberTagInput')
  $el.typeahead
    local    : lclData.memList
    engine   : Hogan
    limit    : 15
    template : "<img src='{{avatar}}' class='icon'/> {{value}}"
  $el.val('')
  $el.focus()

resetTypeAhead = ->
  $el = $('#memberTagInput')
  $el.typeahead('destroy')
  typeAheadInit()

updateTags = ->
  str = $('.tagCell').map(-> $(this).data('name')).get().join()
  $('#memberTagNames').val(str)

window.addMemberTag = (data)->
  htm = """
    <button data-title='click to remove' class='tagCell' data-name='#{data.user_name}'>
      <img style='padding-top: 1px;' src="#{data.avatar}" class='icon'/>
      #{data.value}
    </button>
  """
  $('.twitter-typeahead').before(htm) unless $("#" + "#{data.tag_id}").length > 0
  $("#" + "#{data.tag_id}").effect("highlight", {}, 1000)
  updateTags()
  $('.tagCell').tooltip('destroy').tooltip()
  $('.tagCell').unbind('click').click (ev)=>
    $('.tagCell').tooltip('destroy')
    $(ev.target).remove()
    $('.tagCell').tooltip()
    updateTags()

window.clearAllMemberTags = ->
  $('.tagCell').remove()
  updateTags()
  resetTypeAhead()

$(document).ready ->
  typeAheadInit()
  $('#memberTagInput').on 'typeahead:selected', (ev, data)->
    addMemberTag(data)
    resetTypeAhead()
