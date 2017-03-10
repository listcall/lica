getTitle = ->
  $el = $(this)
  mname = $el.data('mname')
  tname = $el.data('tname')
  """
  <span class="text-info"><strong>#{tname} Cert for #{mname}</strong></span>
  """

getBody = ->
  $el = $(this)
  mId = $el.data('mid')
  qId = $el.data('qid')
  tId = $el.data('tid')
  result = ""
  $.ajax
    url:  "/ajax/memberships/#{mId}/qual_certs/#{tId}?qid=#{qId}"
    type: 'get'
    async: false
    success: (html)->
      result = html
  result

closePops = (e)->
  $(".xlink").each ->
    if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
      $(this).popover "hide"

$(document).ready ->
  $('.xlink').popover
    html:      true
    title:     getTitle
    content:   getBody
    placement: 'auto'
    container: 'body'

  $("body").on "click", (e) ->
    $(".xlink").each ->
      if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
        $(this).popover "hide"

  $('.xlink').on 'shown.bs.popover', ->
    $('.closePop').click (ev)->
      ev.preventDefault()
      $('.closePop').unbind()
      $('.xlink').popover('hide')
