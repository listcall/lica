$(document).ready ->
  $('.inline').editable()
  $('.inlineLbl').editable
    success: -> location.reload()
#  $('.select-rights').editable
#    showbuttons: false
#    source: [{value: "admin", text: "admin"}, {value: "director", text: "director"}, {value: "active", text: "active"}]
#  $('.select-has').editable
#    showbuttons: false
#    source: [{value: "many", text: "many"}, {value: "one", text: "one"}]
  $('.role-one').editable
    type     : 'select'
    source   : memArray
    send     : 'always'
    success  : ->
      console.log "there was success"
      location.reload()
    failure  : ->
      console.log "there was failure"
      location.reload()
  $('.role-many').editable
    type     : 'checklist'
    source   : memArray
    display  : false
    placement: 'left'
    send     : 'always'
    tpl      : "<div style='width: 250px; height: 170px; overflow: scroll;'></div>"
    success  : ->
      console.log "there was success"
      location.reload()
    failure  : ->
      console.log "there was failure"
      location.reload()
