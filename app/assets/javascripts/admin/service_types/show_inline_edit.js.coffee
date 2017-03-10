# old_serv

$.fn.editable.defaults.mode      = "popup"
$.fn.editable.defaults.placement = "bottom"

typeUrl = "/admin/service_types/#{lclData.serviceTypeId}"
typePk  = lclData.serviceTypeId

$(document).ready ->
  $('.nameEditType').editable
    inputclass  : 'textInput'
    url         : typeUrl
    pk          : typePk
    type        : 'text'
    ajaxOptions :
      type   : 'put'
      success: -> location.reload()
  $('.scheduleEditType').editable
    type: 'select'
    url : typeUrl
    pk  : typePk
    ajaxOptions:
      type   : 'put'
      success: -> location.reload()
  $('.textEditType').editable
    inputclass  : 'textInput'
    url         : typeUrl
    pk          : typePk
    type        : 'text'
    ajaxOptions :
      type: 'put'
  $('.selectEditType').editable
    type: 'select'
    url : typeUrl
    pk  : typePk
    ajaxOptions:
      type: 'put'
  $('.areaEditType').editable
    inputclass  : 'textInput'
    url         : typeUrl
    pk          : typePk
    type        : 'textarea'
    ajaxOptions :
      type: 'put'
  $('.selectTime').editable
    type: 'select'
    url : typeUrl
    pk  : typePk
    source: [
      {value: "01:00", text: "01:00"}
      {value: "03:00", text: "03:00"}
      {value: "05:00", text: "05:00"}
      {value: "06:00", text: "06:00"}
      {value: "07:00", text: "07:00"}
      {value: "08:00", text: "08:00"}
      {value: "09:00", text: "09:00"}
      {value: "10:00", text: "10:00"}
      {value: "11:00", text: "11:00"}
      {value: "12:00", text: "12:00"}
      {value: "13:00", text: "13:00"}
      {value: "14:00", text: "14:00"}
      {value: "15:00", text: "15:00"}
      {value: "16:00", text: "16:00"}
      {value: "17:00", text: "17:00"}
      {value: "18:00", text: "18:00"}
      {value: "19:00", text: "19:00"}
      {value: "21:00", text: "21:00"}
      {value: "23:00", text: "23:00"}
    ]
    ajaxOptions:
      type: 'put'
