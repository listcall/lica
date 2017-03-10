# old_serv

$.fn.editable.defaults.mode        = "popup"
$.fn.editable.defaults.send        = "always"
$.fn.editable.defaults.placement   = "bottom"
$.fn.editable.defaults.ajaxOptions = {type: 'put'}

baseUrl = "/admin/service_reps"

sendUpdate = (params)->
  doIt = true
  if $('.tmplFork').hasClass('green')
    doIt = confirm "All edits will be lost!  Are you sure?"
  if doIt
    $.ajax
      type: 'put'
      data: {name: params.name, value: params.value}
      url : "#{baseUrl}/#{params.pk}"

$(document).ready ->
  $('#tmplName').editable
    url: "#{baseUrl}/#{lclData.reportId}"

  $('#pickEdit').editable
    url: "#{baseUrl}/#{lclData.reportId}"

  $('.repTmpl').editable
    url: sendUpdate
    escape: false
    success: ->
      if $('.tmplFork').hasClass('green')
        location.reload()
      else
        document.getElementById("preview").contentDocument.location.reload(true)