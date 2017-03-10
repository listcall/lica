$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.placement = "bottom"
$.fn.editable.defaults.url       = "/ajax/events/#{lclData.eventId}"
$.fn.editable.defaults.pk        = lclData.eventId

alreadyCalled = false
tagList       = []

getUniqTags = ->
  return tagList if alreadyCalled
  alreadyCalled = true
  result = $.ajax
    url:    "/ajax/events/tag_uniq.json"
    async:  false
    method: "GET"
  tagList = JSON.parse(result.responseText)

existingTags = ->
  _.difference(getUniqTags(), $('#tagList').text().split(', '))

titleString = ->
  exTags = existingTags()
  return "Enter new tag(s), separated by spaces." if exTags.length == 0
  "Enter new or existing tags.  (pick from: " + exTags.join(', ') + ")"

updateTagString = ->
  newTxt = $('#tagList').text().toLowerCase()
  $('#tagList').text(newTxt)

$(document).ready ->
  $('.textEditable').editable
    inputclass: 'textInput'
    ajaxOptions:
      type: 'put'
  $('.selectEditable').editable
    ajaxOptions:
      type: 'put'
      success: (ev, data)->
        if ev != lclData.eventRef
          window.location.replace("/events/#{ev}")
    source: JSON.parse(lclData.eSelect)
  $('.select2Editable').editable
    inputclass: 'select2wide'
    title: titleString
    select2:
      tags: getUniqTags
      tokenSeparators: [",", " "]
    ajaxOptions:
      type: 'put'
    success: ->
      setTimeout(updateTagString, 1000)





