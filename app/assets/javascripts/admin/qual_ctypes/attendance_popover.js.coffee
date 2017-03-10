ajaxForm = (ctypeId)->
  $.ajax
    url:    "/ajax/qual_ctypes_attendance/#{ctypeId}"
    async:  false
    method: 'GET'

helpMsg = ->
  ttlHelp = $('#ttlHelp').html()
  typHelp = $('#typHelp').html()
  tagHelp = $('#tagHelp').html()
  $('#typTxt').unbind()
  $('#tagTxt').unbind()
  $('#ttlTxt').unbind()
  $('#ttlTxt').on 'focus', -> $('#helpDiv').html ttlHelp
  $('#ttlTxt').on 'blur' , -> $('#helpDiv').html ""
  $('#typTxt').on 'focus', -> $('#helpDiv').html typHelp
  $('#typTxt').on 'blur' , -> $('#helpDiv').html ""
  $('#tagTxt').on 'focus', -> $('#helpDiv').html tagHelp
  $('#tagTxt').on 'blur' , -> $('#helpDiv').html ""
  $('#closeBtn').unbind().click -> $('.updateAttendance').popover('hide')

submitAction = (ctypeId)->
  $('#submitBtn').unbind().click ->
    opts =
      event_count: $('#eventCount').val()
      title:       $('#ttlTxt').val()
      types:       $('#typTxt').val()
      tags:        $('#tagTxt').val()
      month_count: $('#monthCount').val()
    $.ajax
      url:    "/ajax/qual_ctypes_attendance/#{ctypeId}"
      data:   opts
      method: 'put'
    $('.updateAttendance').popover('hide')

displayPopover = (ctypeId)->
  html = ajaxForm(ctypeId).responseText
  $('.popover-content').html(html)
  helpMsg()
  submitAction(ctypeId)

$(document).ready ->

  $("body").on "click", (e) ->
    $(".updateAttendance").each ->
      if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
        $(this).popover "hide"

  $('.updateAttendance').popover
    html:      true
    title:     'Valid if member attends:'
    content:   "<div class='loadingDiv'>Loading...</div>"
    placement: 'auto'
    container: 'body'

  $('.updateAttendance').on 'show.bs.popover', ->
    ctypeId = $(this).data('pk')
    $(this).data('bs.popover').tip().css(width: '440px', maxWidth: '440px')
    setTimeout(displayPopover, 250, ctypeId)