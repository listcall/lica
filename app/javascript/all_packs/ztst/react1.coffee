components = require("../../ztst/react1")

$(document).ready ->
  React.render components.hello(), $('#example1')[0]
  React.render React.createElement(components.typeAhead), $('#typetest')[0]
