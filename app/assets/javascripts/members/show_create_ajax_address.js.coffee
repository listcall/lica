submitAddressCreateForm = (ev)->
  ev.preventDefault()
  console.log "CREATING ADDRESS"
  address1 = $('#user_address_address1').val()
  address2 = $('#user_address_address2').val()
  city     = $('#user_address_city').val()
  state    = $('#user_address_state').val()
  zip      = $('#user_address_zip').val()
  typ      = $('#user_address_typ').val()
  visible  = if $('#user_address_visible').is(':checked') then '1' else '0'
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/addresses"
    type : 'post'
    data :
      "address[address1]" : address1
      "address[address2]" : address2
      "address[city]"     : city
      "address[state]"    : state
      "address[zip]"      : zip
      "address[typ]"      : typ
      "address[visible]"  : visible
    success: (data)->
      location.reload()
    error: (data)->
      loadAddressCreateForm(data.responseText)

loadAddressCreateForm = (data)->
  $('#createBody').html(data)
  $('.switch-box').bootstrapSwitch()
  $('#user_address_address1').focus()
  $('#SaveBtn').click submitAddressCreateForm

setupAddressCreateForm = ->
  $('#createModal').modal()
  $('#createType').text('Address')
  $('#createName').text(memFirstName)
  $.ajax
    url  : "/ajax/memberships/#{window.memId}/addresses/new.html"
    type : 'get'
    success: (data)->
      loadAddressCreateForm(data)

$(document).ready ->
  $('#addressCreate').click setupAddressCreateForm