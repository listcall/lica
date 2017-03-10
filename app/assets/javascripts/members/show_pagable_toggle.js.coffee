gPhone = 'fa-bullhorn green_phone'
rPhone = 'fa-ban red_phone'
gEmail = 'fa-bullhorn green_email'
rEmail = 'fa-ban red_email'

setPagableItem = (element, value, type)->
  id = element.id.split('_')[1]
  $.ajax
    url:  "/ajax/memberships/#{window.memId}/#{type}s/#{id}"
    type: 'put'
    data:
      name: "pagable"
      value: value

setPagablePhone = (element, value)-> setPagableItem(element, value, 'phone')
setPagableEmail = (element, value)-> setPagableItem(element, value, 'email')

phoneOn = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass rPhone
  $(ele).addClass    gPhone
  setPagablePhone(ele, 1)
  $(ele).click phoneOff

phoneOff = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass gPhone
  $(ele).addClass    rPhone
  setPagablePhone(ele, 0)
  $(ele).click phoneOn

emailOn = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass rEmail
  $(ele).addClass    gEmail
  setPagableEmail(ele, 1)
  $(ele).click emailOff

emailOff = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass gEmail
  $(ele).addClass    rEmail
  setPagableEmail(ele, 0)
  $(ele).click emailOn

$(document).ready ->
  $('.pagable').find('.green_phone').click phoneOff
  $('.pagable').find('.red_phone').click   phoneOn
  $('.pagable').find('.green_email').click emailOff
  $('.pagable').find('.red_email').click   emailOn
