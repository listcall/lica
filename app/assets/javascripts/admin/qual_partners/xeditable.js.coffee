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
  $('.updateDescription').editable
    type: "text"
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
    display: (value, _src)-> $(this).html(value.join(', '))
