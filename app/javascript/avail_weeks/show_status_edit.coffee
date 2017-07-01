sendAjax = (pk, status)->
  $.ajax
    url   : "/services/#{lclData.serviceId}/avail_weeks/#{lclData.memberName}"
    method: 'put'
    data  : {name: 'status', pk: pk, value: status}

allToAvail = ->
  $('#allAvail').blur()
  $('.avail').not('.active').each (idx, el)->
    $el = $(el)
    pk  = $el.data('pk')
    $el.addClass('active')
    $el.parent().find("#unava_#{pk}").removeClass('active')
    sendAjax(pk, 'available')

allToUnava = ->
  $('#allUnava').blur()
  $('.unava').not('.active').each (idx, el)->
    $el = $(el)
    pk  = $el.data('pk')
    $el.addClass('active')
    $el.parent().find("#avail_#{pk}").removeClass('active')
    sendAjax(pk, 'unavailable')

processAvailClick = (ev)->
  $tgt = $(ev.target)
  pk   = $tgt.data('pk')
  if $tgt.hasClass('active')
    $tgt.removeClass('active').blur()
    sendAjax(pk, '')
  else
    $tgt.addClass('active')
    $tgt.parent().find("#unava_#{pk}").removeClass('active')
    sendAjax(pk, 'available')

processUnavaClick = (ev)->
  $tgt   = $(ev.target)
  pk     = $tgt.data('pk')
  if $tgt.hasClass('active')
    $tgt.removeClass('active').blur()
    sendAjax(pk, '')
  else
    $tgt.addClass('active')
    $tgt.parent().find("#avail_#{pk}").removeClass('active')
    sendAjax(pk, 'unavailable')

$(document).ready ->
  $('.avail').click processAvailClick
  $('.unava').click processUnavaClick
  $('#allAvail').click allToAvail
  $('#allUnava').click allToUnava

