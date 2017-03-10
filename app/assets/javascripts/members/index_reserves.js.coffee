processReserveClick = ->
  $el = $('#reserveCheckBox')
  if $el.prop('checked')
    $.cookie('member_reserves', 'true')
  else
    $.cookie('member_reserves', 'false')
  location.reload()

$(document).ready ->
  $('#reserveCheckBox').click processReserveClick