propExists = (object, property)-> object.hasOwnProperty(property)

$.fn.editable.defaults.mode = 'popup'

resetURL = (newUserName)->
  console.log "DOING RESET", newUserName
  currentURL          = document.URL
  currentArr          = currentURL.split('/')
  lastIdx             = currentArr.length - 1
  currentArr[lastIdx] = newUserName
  newURL              = currentArr.join('/')
  currentTitle        = document.title
  if propExists(window, "history")
    console.log "doing replace state", newURL
    window.history.replaceState({}, currentTitle, newURL)
  else
    console.log "reloading page"
    window.location.replace(newURL)

$(document).ready ->
  $('.phoneNumber').editable
    ajaxOptions:
      type: 'put'
#      success: (data)->
#         if data.success == true
#           data.msg
#         else
#           ""
  $('.phoneTyp, .contactTyp').editable
    ajaxOptions:
      type: 'put'
      success: -> location.reload()
    source: [
      {value: "Mobile", text: "Mobile"}
      {value: "Work",   text: "Work"}
      {value: "Home",   text: "Home"}
      {value: "Pager",  text: "Pager"}
    ]
  $('.emailAddress').editable
    ajaxOptions:
      type: 'put'
  $('.userName').editable
    ajaxOptions:
      type: 'put'
    success: (_x, newUserName)->
      resetURL(newUserName)
    error: -> console.log "THERE WAS ERROR"
  $('.emailTyp').editable
    ajaxOptions:
      type: 'put'
    source: [
      {value: "Personal",  text: "Personal"}
      {value: "Work",      text: "Work"}
      {value: "Home",      text: "Home"}
    ]
  $('.addressTyp').editable
    ajaxOptions:
      type: 'put'
    source: [
      { value: "Work",      text: "Work"  }
      { value: "Home",      text: "Home"  }
      { value: "Other",     text: "Other" }
    ]
