#formData = ->
#  list = $('#certForm').serializeArray()
#  comb = (acc, el)->
#    obj = {}
#    obj[el.name] = el.value
#    $.extend(acc, obj)
#  data  = _.reduce list, comb, {}
#  data

submitCreateForm = (ev)->
  ev.preventDefault()
  console.log "Creating Cert"
  data = new FormData($('#certForm')[0])
  $.ajax
    url  : "/ajax/memberships/#{window.memberName}/certs"
    type : 'post'
    processData: false
    contentType: false
    data : data
    success: (data)->
      location.reload()
    error: (data)->
      loadCreateForm(data.responseText)

loadCreateForm = (html)->
  $('#formBody').html(html)
  $('#certForm').attr('action', "/ajax/memberships/#{window.memberName}/certs")
  $('#certSaveBtn').click submitCreateForm

createModal = (ev)->
  typeId  = $(ev.target).data("tid")
  typeKey = $(ev.target).data("tkey")
  $('#modTitle').text("Create #{typeKey}")
  $('#myModal').modal()
  $.ajax
    url:  "/ajax/memberships/#{window.memberName}/certs/new.html"
    data: {qual_ctype_id: typeId}
    type: "get"
    success: (html)->
      loadCreateForm(html)

$(document).ready ->
  $('.certCreateBtn').click (ev)-> createModal(ev)
