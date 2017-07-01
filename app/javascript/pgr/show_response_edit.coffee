ajaxForm = (dialogId, asid)->
  $.ajax
    url:    "/ajax/action_op_rsvp/#{dialogId}?asid=#{asid}"
    async:  false
    method: 'GET'

showPopover = (el)->
  $el = $(el.target)
  dialogId = $el.data('pk')
  aSID     = $el.data('asid')
  html     = ajaxForm(dialogId, aSID).responseText
  title    = $(html).data('title')
  opts     =
    html      : true
    title     : title
    content   : html
    placement : 'auto'
    container : 'body'
  $el.popover(opts).popover('show')
  console.log "BNIG BONG"
  $('.closePop').click resetPopover

resetPopover = ->
  $('.actLink').popover('destroy').unbind().click(showPopover).on 'hide.bs.popover', ->
    setTimeout(resetPopover, 100)

$('document').ready ->
  resetPopover()
