window.resetTooltips = ->
  $('.tClk').tooltip('destroy')
  $('.tClk').tooltip({placement: 'top'})

$(document).ready ->
  resetTooltips()