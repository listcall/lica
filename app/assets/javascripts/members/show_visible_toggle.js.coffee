gPhone = 'fa-eye       visible_phone'
rPhone = 'fa-eye-slash obscure_phone'
gEmail = 'fa-eye       visible_email'
rEmail = 'fa-eye-slash obscure_email'
gAddrs = 'fa-eye       visible_addrs'
rAddrs = 'fa-eye-slash obscure_addrs'
gConta = 'fa-eye       visible_conta'
rConta = 'fa-eye-slash obscure_conta'

setVisibleItem = (element, value, type)->
  id = element.id.split('_')[2]
  $.ajax
    url:  "/ajax/memberships/#{window.memId}/#{type}/#{id}"
    type: 'put'
    data:
      name: "visible"
      value: value

setVisiblePhone   = (element, value)-> setVisibleItem(element, value, 'phones')
setVisibleEmail   = (element, value)-> setVisibleItem(element, value, 'emails')
setVisibleAddress = (element, value)-> setVisibleItem(element, value, 'addresses')
setVisibleContact = (element, value)-> setVisibleItem(element, value, 'contacts')

contactOn = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass rConta
  $(ele).addClass    gConta
  setVisibleContact(ele, 1)
  $(ele).click contactOff

contactOff = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass gConta
  $(ele).addClass    rConta
  setVisibleContact(ele, 0)
  $(ele).click contactOn

phoneOn = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass rPhone
  $(ele).addClass    gPhone
  setVisiblePhone(ele, 1)
  $(ele).click phoneOff

phoneOff = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass gPhone
  $(ele).addClass    rPhone
  setVisiblePhone(ele, 0)
  $(ele).click phoneOn

emailOn = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass rEmail
  $(ele).addClass    gEmail
  setVisibleEmail(ele, 1)
  $(ele).click emailOff

emailOff = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass gEmail
  $(ele).addClass    rEmail
  setVisibleEmail(ele, 0)
  $(ele).click emailOn

addressOn = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass rAddrs
  $(ele).addClass    gAddrs
  setVisibleAddress(ele, 1)
  $(ele).click addressOff

addressOff = (ev)->
  ele = ev.currentTarget
  $(ele).removeClass gAddrs
  $(ele).addClass    rAddrs
  setVisibleAddress(ele, 0)
  $(ele).click addressOn

$(document).ready ->
  $('.visible_phone').click  phoneOff
  $('.obscure_phone').click  phoneOn
  $('.visible_email').click  emailOff
  $('.obscure_email').click  emailOn
  $('.visible_addrs').click  addressOff
  $('.obscure_addrs').click  addressOn
  $('.visible_conta').click  contactOff
  $('.obscure_conta').click  contactOn