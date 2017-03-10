deletePhone = (ev)->
  el = ev.currentTarget
  return unless confirm "Are you sure?"
  id = el.id.split('_')[1]
  $.ajax
    url:  "/ajax/memberships/#{window.memId}/phones/#{id}"
    type: 'delete'
    complete: -> location.reload()

deleteEmail = (ev)->
  el = ev.currentTarget
  return unless confirm "Are you sure?"
  id = el.id.split('_')[1]
  $.ajax
    url:  "/ajax/memberships/#{window.memId}/emails/#{id}"
    type: 'delete'
    complete: -> location.reload()

deleteAddress = (ev)->
  el = ev.currentTarget
  return unless confirm "Are you sure?"
  id = el.id.split('_')[1]
  $.ajax
    url:  "/ajax/memberships/#{window.memId}/addresses/#{id}"
    type: 'delete'
    complete: -> location.reload()

deleteContact = (ev)->
  el = ev.currentTarget
  return unless confirm "Are you sure?"
  id = el.id.split('_')[1]
  $.ajax
    url:  "/ajax/memberships/#{window.memId}/contacts/#{id}"
    type: 'delete'
    complete: -> location.reload()

$(document).ready ->
  $('.phoneDel').click deletePhone
  $('.emailDel').click deleteEmail
  $('.addressDel').click deleteAddress
  $('.contactDel').click deleteContact