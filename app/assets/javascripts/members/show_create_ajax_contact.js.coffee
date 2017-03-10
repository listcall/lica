submitContactCreateForm = (ev)->
  ev.preventDefault()
  console.log "CREATING CONTACT"
  name          = $('#user_emergency_contact_name').val()
  kinship       = $('#user_emergency_contact_kinship').val()
  phone_number  = $('#user_emergency_contact_phone_number').val()
  phone_type    = $('#user_emergency_contact_phone_type').val()
  visible       = if $('#user_emergency_contact_visible').is(':checked') then '1' else '0'
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/contacts"
    type : 'post'
    data :
      "contact[name]"          : name
      "contact[kinship]"       : kinship
      "contact[phone_number]"  : phone_number
      "contact[phone_type]"    : phone_type
      "contact[visible]"       : visible
    success: (data)->
      location.reload()
    error: (data)->
      loadContactCreateForm(data.responseText)

loadContactCreateForm = (data)->
  $('#createBody').html(data)
  $('.switch-box').bootstrapSwitch()
  $('#user_emergency_contact_name').focus()
  $('#SaveBtn').click submitContactCreateForm

setupContactCreateForm = ->
  $('#createModal').modal()
  $('#createType').text('Contact')
  $('#createName').text(memFirstName)
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/contacts/new.html"
    type : 'get'
    success: (data)->
      loadContactCreateForm(data)

$(document).ready ->
  $('#contactCreate').click setupContactCreateForm