#helloComponent = require("zcst/react0")

D = React.DOM

helloComponent = ->
  D.div {},
    "hello von coffee (react99)"
    D.br {}
    D.b  {}, "Hello World from Coffee!"
    D.br {}
    D.h3 {}, "This is an h3 from the Hello component!!"

#module.exports = helloComponent

$(document).ready ->
  React.render helloComponent(), $('#example0')[0]
