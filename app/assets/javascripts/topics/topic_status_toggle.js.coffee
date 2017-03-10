setTopicStatus = (ele, status)->
  id  = ele.id.split('_')[1]
  console.log "PAGE TYPE", window.pageType
  $.ajax
    url:  "/ajax/topic_status/#{id}"
    type: 'put'
    data:
      membership_id: window.memId
      status:        status
    complete: -> location.reload() if window.pageType == "show"

setStatusOpen = (ev)->
  ele = ev.currentTarget
  id  = ele.id.split('_')[1]
  return if $("#tStatO_#{id}").hasClass("active")
  setTopicStatus(ele, "Open")
  window.location.reload() if window.pageType == "show"

setStatusClosed = (ev)->
  ele = ev.currentTarget
  id  = ele.id.split('_')[1]
  return if $("#tStatC_#{id}").hasClass("active")
  setTopicStatus(ele, "Closed")
  window.location.reload() if window.pageType == "show"

$(document).ready ->
  $('.statusToggle').on 'switch-change', (e, data)->
    value = data.value
    if value == true
      setStatusOpen(e)
    else
      setStatusClosed(e)
