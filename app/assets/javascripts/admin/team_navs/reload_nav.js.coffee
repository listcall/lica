window.ADM = window.ADM || {}

ADM.reloadNav = ->
  ADM.reloadHeaderNav()
  ADM.reloadFooterNav()

ADM.reloadHeaderNav = ->
  $.get "/nav/header", {}, (data) ->
    $('.hNav').remove()
    $('#headerNav').prepend(data)

ADM.reloadFooterNav = ->
  $.get "/nav/footer", {}, (data) ->
    $('#footerNav').html(data)