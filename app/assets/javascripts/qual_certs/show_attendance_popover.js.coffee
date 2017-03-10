ajaxForm = (certId)->
  $.ajax
    url:    "/ajax/qual_attendance/#{certId}"
    async:  false
    method: 'GET'

displayPopover = (ctypeId)->
  html = ajaxForm(ctypeId).responseText

setupHidePopover = ->
  $('.closePop').unbind().on 'click', ->
    $('.atLnk').popover('hide')

getText = (el)->
  certId = $(el).data('certid')
  ajaxForm(certId).responseText

$(document).ready ->

  $("body").on "click", (e) ->
    $(".atLnk").each ->
      if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
        $(this).popover "hide"

  $('.atLnk').popover
    html:      true
    content:   -> getText(this)
    placement: 'right'
    container: 'body'

  $('.atLnk').on 'show.bs.popover', ->
    setTimeout(setupHidePopover, 250)