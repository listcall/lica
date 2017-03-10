$(document).ready ->
  $('.updateName').editable
    type: "text"
    ajaxOptions:
      type: 'put'
  $('.updateAcronym').editable
    type: "text"
    ajaxOptions:
      type: 'put'
    success: -> location.reload()
  $('.updateSelectMethod').editable
    type: "select"
    source: ['free_text', 'distinct_list', 'fixed_list']
    ajaxOptions:
      type: 'put'
    success: -> location.reload()
  $('.updateSelectList').editable
    type: "textarea"
    display: false
    placement: 'right'
    title: "enter select options, one per line"
    ajaxOptions:
      type: 'put'
  $('.updateTitlePlaceholder').editable
    type: "text"
    display: false
    title: "title placeholder"
    ajaxOptions:
      type: 'put'
  $('.updateDocformats').editable
    type: "checklist"
    source: [
      { value: 'link', text: 'link'},
      { value: 'file', text: 'file'},
      { value: 'comment', text: 'comment'}
    ]
    ajaxOptions:
      type: 'put'
    display: (value, _src)->
      return "" if value == null
      $(this).html(value.join(', '))
  $('.updateEvidence').editable
    type: "checklist"
    success: -> location.reload()
    source: [
      { value: 'link'          , text: 'link'}
      { value: 'file'          , text: 'file'},
      { value: 'attendance'    , text: 'attendance'}
    ]
    ajaxOptions:
      type: 'put'
