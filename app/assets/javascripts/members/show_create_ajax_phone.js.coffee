showPagableRow = -> $('#pagableRow').show()
hidePagableRow = -> $('#pagableRow').hide()

setPagableVisibility = ->
  val = $('#user_phone_typ').val()
  switch val
    when 'Mobile', 'Pager'
      showPagableRow()
    else hidePagableRow()

submitPhoneCreateForm = (ev)->
  ev.preventDefault()
  number  = $('#user_phone_number').val()
  typ     = $('#user_phone_typ').val()
  pagable = if $('#user_phone_pagable').is(':checked') then '1' else '0'
  visible = if $('#user_phone_visible').is(':checked') then '1' else '0'
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/phones"
    type : 'post'
    data :
      "phone[number]"  : number
      "phone[typ]"     : typ
      "phone[pagable]" : pagable
      "phone[visible]" : visible
    success: (data)->
      location.reload()
    error: (data)->
      loadPhoneCreateForm(data.responseText)

loadPhoneCreateForm = (data)->
  $('#createBody').html(data)
  $('.switch-box').bootstrapSwitch()
  setPagableVisibility()
  $('#user_phone_number').focus()
  $('#user_phone_typ').change setPagableVisibility
  $('#SaveBtn').click submitPhoneCreateForm

setupPhoneCreateForm = ->
  $('#createModal').modal()
  $('#createType').text('Phone')
  $('#createName').text(memFirstName)
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/phones/new.html"
    type : 'get'
    success: (data)->
      loadPhoneCreateForm(data)

$(document).ready ->
  $('#phoneCreate').click setupPhoneCreateForm