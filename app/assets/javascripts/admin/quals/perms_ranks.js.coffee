getRankSource = ->
  data = $.ajax
    url:    "/admin/member_ranks/list"
    async:  false
    method: "GET"
  JSON.parse(data.responseText)

# make the field editable
setEditableRank = (selector)=>
  $(selector).editable
    type: "checklist"
    source: window.roleSource
    placement: "bottom"
    emptytext: "Ranks"
    ajaxOptions:
      type: 'put'
    display: (value, _src)->
      arrayVal = [].concat(value)
      $(this).html(arrayVal.join(', '))

$(document).ready ->
  window.roleSource = getRankSource()
  setEditableRank('.rankX')