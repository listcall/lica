$(document).ready ->
  $('.contact').editable
    ajaxOptions:
      type: 'put'
    send      : 'always'
    placement : 'top'