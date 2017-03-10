getRoleSource = ->
  data = $.ajax
    url:    "/admin/member_roles/list"
    async:  false
    method: "GET"
  JSON.parse(data.responseText)

# make the field editable
setEditableRole = (selector)=>
  $(selector).editable
    type: "checklist"
    source: window.roleSource
    placement: "bottom"
    emptytext: "Select Roles"
    ajaxOptions:
      type: 'put'
    display: (value, _src)-> $(this).html(value.join(', '))

$(document).ready ->
  window.roleSource = getRoleSource()
  setEditableRole('.roleX')