#= require ./show_shared

submitEditForm = (ev, certId)->
  ev.preventDefault()
  data = new FormData($('#certForm')[0])
  $.ajax
    url  : "/ajax/memberships/#{window.memberName}/certs/#{certId}"
    type : 'put'
    processData: false
    contentType: false
    data : data
    success: (data)->
      location.reload()
    error: (data)->
      console.log "THERE WAS AN ERROR"
      loadEditForm(data.responseText)

loadEditForm = (html, certId)->
  $('#formBody').html(html)
  $('#certSaveBtn').unbind()
  $('#certSaveBtn').click (ev)=> submitEditForm(ev, certId)
  Shared.setupTitleField()
  Shared.setupEvidenceField()
  Shared.setupDatepicker()

editModal = (ev)->
  $('#formBody').text("Loading...")
  typeKey = $(ev.target).data("tkey")
  typeId  = $(ev.target).data("tid")
  certId  = ev.target.id.split('_')[1]
  $('#modTitle').text("Edit #{typeKey}")
  $('#myModal').modal()
  $.ajax
    url:  "/ajax/memberships/#{window.memberName}/certs/#{certId}/edit.html"
    data: {qual_ctype_id: typeId}
    type: "get"
    success: (html)=>
      loadEditForm(html, certId)

$(document).ready ->
  $('.certEditBtn').click (ev)-> editModal(ev)
