$(document).ready ->
  $('.updateName').editable
    type: "text"
    display: (val, data)->
      output = if val.length > 17 then val.substring(0,15) + "..." else val
      $(this).text(output)

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
