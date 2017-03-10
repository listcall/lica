getRankSource = ->
  data = $.ajax
    url:    "/admin/member_ranks/list"
    async:  false
    method: "GET"
  JSON.parse(data.responseText)

getRoleSource = ->
  data = $.ajax
    url:    "/admin/member_roles/list"
    async:  false
    method: "GET"
  JSON.parse(data.responseText)

# make the field editable
setEditableRank = (selector)=>
  $(selector).editable
    type: "select"
    placement: "bottom"
    source: window.rankSource

# make the field editable
setEditableRole = (selector)=>
  $(selector).editable
    type: "checklist"
    placement: "bottom"
    source: window.roleSource

# update the row after the edit is performed
setUpdatableType = (selector)=>
  $(selector).on 'save', (e, params)->
    row  = params.response      # an html row is returned from the update action
    id   = $(row).attr('id')    # grab the id from the html row
    html = $(row).html()        # grab the html from the row
    $("#" + "#{id}").html(html) # insert the html into the DOM
    setEditableRank("##{id} .rankX")
    setEditableRole("##{id} .roleX")
    setUpdatableType("##{id} .xEdit")

$(document).ready ->
  window.rankSource = getRankSource()
  window.roleSource = getRoleSource()
  setEditableRank('.rankX')
  setEditableRole('.roleX')
  setUpdatableType('.xEdit')