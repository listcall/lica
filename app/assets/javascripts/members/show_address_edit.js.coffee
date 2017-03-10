$(document).ready ->
  $('.addressVal').editable
    ajaxOptions:
      type: 'put'
    send      : 'always'
    placement : 'top'