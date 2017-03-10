processReserveClick = ->
  $el = $('#reserveCheckBox')
  if $el.prop('checked')
    $.cookie('paging_new_reserves', 'true')
  else
    $.cookie('paging_new_reserves', 'false')
  location.reload()

$(document).ready ->
  $('#reserveCheckBox').click processReserveClick