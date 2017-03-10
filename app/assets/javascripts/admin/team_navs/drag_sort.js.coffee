#= require ./reload_nav

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

$(document).ready ->
  $('#navHdrBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/team_navs/sort"
        type: 'post'
        data: $('#navHdrBody').sortable("serialize",{expression:(/(.+)_(.+)/)})
        dataType: 'script'
        error:   -> ADM.reloadHeaderNav()
  $('#navHdrBody').disableSelection()

$(document).ready ->
  $('#navFtrBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/team_navs/sort"
        type: 'post'
        data: $('#navFtrBody').sortable("serialize",{expression:(/(.+)_(.+)/)})
        dataType: 'script'
        error:   -> ADM.reloadFooterNav()
  $('#navFtrBody').disableSelection()

$(document).ready ->
  $('#navHomeBody').sortable
    axis: 'y'
    opacity: 0.4
    handle:  '.fa-arrows-v'
    update: ->
      $.ajax
        url:  "/admin/team_navs/sort"
        type: 'post'
        data: $('#navHomeBody').sortable("serialize",{expression:(/(.+)_(.+)/)})
        dataType: 'script'
  $('#navHomeBody').disableSelection()
