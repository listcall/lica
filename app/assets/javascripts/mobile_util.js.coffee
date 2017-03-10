# ----- cookie support -----

window.createCookie = (name, value, days) ->
  if days
    date = new Date()
    date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
    expires = "; expires=" + date.toGMTString()
  else
    expires = ""
  document.cookie = name + "=" + value + expires + "; path=/"

window.readCookie = (name) ->
  nameEQ = name + "="
  ca = document.cookie.split(";")
  i = 0

  while i < ca.length
    c = ca[i]
    c = c.substring(1, c.length)  while c.charAt(0) is " "
    return c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
    i++
  null

window.eraseCookie = (name) ->
  createCookie name, "", -1

window.returnSelf = (object) -> object

# ----- mobile device support -----

devMatch = (regEx, agent = navigator.userAgent)->
  agent.toLowerCase().match regEx


window.deviceName = ->
  return "Android"     if devMatch(/android/) || devMatch(/android/, navigator.platform)
  return "Kindle"      if devMatch /kindle/
  return "Firefox"     if devMatch /firefox/
  return "Chrome"      if devMatch /chrome/
  return "iPod"        if devMatch /ipod/
  return "iPhone"      if devMatch /iphone/
  return "iPad"        if devMatch /ipad/
  return "BlackBerry"  if devMatch /blackberry/
  return "IE"          if devMatch /msie/
  return "Silk"        if devMatch /silk/
  return "Safari"      if devMatch /safari/
  return "Opera"       if devMatch /opera/
  return "Netscape"    if devMatch /netscape/
  return "Konqueror"   if devMatch /konqueror/
  "Unknown"

window.isPhone = ->
  window.deviceName() in ["Android", "BlackBerry", "iPhone"]

window.notPhone = -> ! isPhone()

window.mobileDevice = ->
  window.deviceName() in ["Silk", "Kindle", "Android", "BlackBerry", "iPhone", "iPod"]

window.touchDevice = ->
  window.deviceName() in ["Silk", "Kindle", "Android", "BlackBerry", "iPhone", "iPad", "iPod"]

window.iDevice = ->
  window.deviceName() in ["iPhone", "iPad", "iPod"]

window.iScrollDevice = ->
  window.deviceName() in ["iPad"]

window.topDevice = ->
  window.deviceName() in ["Android", "iPad", "iPod", "iPhone", "Silk", "Kindle"]

window.browserDevice = ->
  window.deviceName() in ["Firefox", "Chrome", "IE", "Safari", "Netscape"]

window.desktopOrIpadDevice = ->
  window.browserDevice() || window.iScrollDevice()

