D = React.DOM

wipComponent = ->
  D.div {},
    "WIP (react)"
    D.br {}
    D.b  {}, "WIP Hello World"
    D.br {}
    D.h3 {}, "This is an h3"

$(document).ready ->
  console.log "wip hello"
  React.render wipComponent(), $('#example0')[0]

