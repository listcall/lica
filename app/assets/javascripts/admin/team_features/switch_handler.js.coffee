setFeature = (featureId, action, callback)->
  $.ajax
    url:  "/admin/team_features"
    type: 'put'
    data: {feature: featureId, turnTo: action}
    dataType: 'script'
    success: -> callback()
    error:   -> callback()

reloadHeaderNav = ->
  $.get "/nav/header", {}, (data) ->
    $('#headerNav').html(data)

reloadAdminNav = ->
  $.get "/nav/admin", {}, (data) ->
    $('#adminNav').html(data)

reloadFooterNav = ->
  $.get "/nav/footer", {}, (data) ->
    $('#footerNav').html(data)

reloadAllNav = ->
  reloadHeaderNav()
  reloadAdminNav()
  reloadFooterNav()

$(document).ready ->
  $('.switch').on 'switch-change', (e, data)->
    feature = $(data.el)[0].id
    action  = if data.value == true then "on" else "off"
    callback = if action == "on" then reloadAdminNav else reloadAllNav
    setFeature(feature, action, callback)