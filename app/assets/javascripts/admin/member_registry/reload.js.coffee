window.ADM = window.ADM || {}

ADM.reloadNav = ->
  ADM.reloadHeaderNav()
  ADM.reloadFooterNav()

ADM.reloadHeaderNav = ->
  $.get "/nav/header", {}, (data) ->
    $('#headerNav').html(data)

ADM.reloadFooterNav = ->
  $.get "/nav/footer", {}, (data) ->
    $('#footerNav').html(data)