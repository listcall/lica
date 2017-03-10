$(document).ready ->
  $('.fullName').editable
    ajaxOptions:
      type: 'put'
    send      : 'always'
    placement : 'bottom'
#    success   : -> console.log "SUCCESS EDITABLE"
