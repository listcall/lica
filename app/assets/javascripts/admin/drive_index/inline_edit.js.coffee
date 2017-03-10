$(document).ready ->
  $('.updateName').editable
    type: "text"
    ajaxOptions:
      type: 'put'
  $('.updateType').editable
    type: "select"
    source: [{value: "FmDiscussion", text: "Discussion"}, {value: "FmIssue", text: "Issue"}]
    ajaxOptions:
      type: 'put'



