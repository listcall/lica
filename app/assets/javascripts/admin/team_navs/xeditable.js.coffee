#= require ./reload_nav

setEditableInline = (selector)=>
  $(selector).editable
    type: "text"
    success: -> ADM.reloadNav()
    error:   -> ADM.reloadNav()
    display: (val, data)->
      output = if val.length > 17 then val.substring(0,15) + ".." else val
      $(this).text(output)

setEditableType = (selector)=>
  $(selector).editable
    type: "select"
    source: ->
      data = $.ajax
        url:    "/admin/team_navs/typelist"
        async:  false
        method: "GET"
      JSON.parse(data.responseText)

setUpdatableType = (selector)=>
  $(selector).on 'save', (e, params)->
    location.reload()

$(document).ready ->
  setEditableInline('.inline')
  setEditableType('.navType')
  setUpdatableType('.navType')