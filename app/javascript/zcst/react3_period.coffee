$(document).ready ->
  console.log "loading periods"
  $(".box").draggable({
    cursor : "pointer"
    axis   : 'x'
    snap: ".drop"
    snapMode: "inner"
    containment: "#containRow"
    start  : (ev)->
      x = ev.pageX
      y = ev.pageY
      console.log "DRAG HAS STARTED", x, y
  })

  $(".drop").droppable({
    hoverClass : "over"
    drop       : -> console.log "Dropping"
    tolerance  : "intersect"
  })