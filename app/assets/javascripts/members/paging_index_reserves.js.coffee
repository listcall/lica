processReserveClick = ->
  $el = $('#reserveCheckBox')
  if $el.prop('checked')
    $.cookie('paging_reserves', 'true')
  else
    $.cookie('paging_reserves', 'false')
  location.reload()

$(document).ready ->
  $('#reserveCheckBox').click processReserveClick