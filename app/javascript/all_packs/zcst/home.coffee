D = React.DOM

homeComponent = ->
  D.div {},
    "Home Page (javascript)"
    D.br {}
    D.b  {}, "Home component"
    D.br {}
    D.h3 {}, "This is an h3"

$(document).ready ->
  React.render homeComponent(), $('#example0')[0]
