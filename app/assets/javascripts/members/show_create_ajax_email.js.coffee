submitEmailCreateForm = (ev)->
  ev.preventDefault()
  console.log "CREATING EMAIL"
  address = $('#user_email_address').val()
  typ     = $('#user_email_typ').val()
  pagable = if $('#user_email_pagable').is(':checked') then '1' else '0'
  visible = if $('#user_email_visible').is(':checked') then '1' else '0'
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/emails"
    type : 'post'
    data :
      "email[address]" : address
      "email[typ]"     : typ
      "email[pagable]" : pagable
      "email[visible]" : visible
    success: (data)->
      location.reload()
    error: (data)->
      loadEmailCreateForm(data.responseText)

loadEmailCreateForm = (data)->
  $('#createBody').html(data)
  $('.switch-box').bootstrapSwitch()
  $('#user_email_address').focus()
  $('#SaveBtn').click submitEmailCreateForm

setupEmailCreateForm = ->
  $('#createModal').modal()
  $('#createType').text('Email')
  $('#createName').text(memFirstName)
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/emails/new.html"
    type : 'get'
    success: (data)->
      loadEmailCreateForm(data)

$(document).ready ->
  $('#emailCreate').click setupEmailCreateForm