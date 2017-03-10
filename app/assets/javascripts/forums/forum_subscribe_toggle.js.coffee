setSubscribableForum = (action, url, id)->
  $.ajax
    url:  url
    type: action
    data:
      name:  "forum_id"
      value: id

createForumSubscription = (ele)->
  id  = ele.id.split('_')[1]
  url = "/ajax/memberships/#{window.memId}/forum_subscriptions"
  action = 'post'
  setSubscribableForum(action, url, id)

deleteForumSubscription = (ele)->
  id  = ele.id.split('_')[1]
  url = "/ajax/memberships/#{window.memId}/forum_subscriptions/#{id}"
  action = 'delete'
  setSubscribableForum(action, url, id)

$(document).ready ->
  $('.watchToggle').on 'switch-change', (e, data)->
    value = data.value
    if value == true
      createForumSubscription(e.target)
    else
      deleteForumSubscription(e.target)
