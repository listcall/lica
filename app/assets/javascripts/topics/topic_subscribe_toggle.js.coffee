setSubscribableTopic = (action, url, id)->
  $.ajax
    url:  url
    type: action
    data:
      name:  "topic_id"
      value: id

createTopicSubscription = (ele)->
  id  = ele.id.split('_')[1]
  url = "/ajax/memberships/#{window.memId}/topic_subscriptions"
  action = 'post'
  setSubscribableTopic(action, url, id)

deleteTopicSubscription = (ele)->
  id  = ele.id.split('_')[1]
  url = "/ajax/memberships/#{window.memId}/topic_subscriptions/#{id}"
  action = 'delete'
  setSubscribableTopic(action, url, id)

$(document).ready ->
  $('.watchToggle').on 'switch-change', (e, data)->
    value = data.value
    if value == true
      createTopicSubscription(e.target)
    else
      deleteTopicSubscription(e.target)
