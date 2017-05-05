require("ztst/react4_ex1")

Ex2      = require("ztst/react4_ex2")
Link     = require("ztst/react4_link")
React    = require("react")
ReactDOM = require("react-dom")

$(document).ready ->
  ReactDOM.render(React.createElement(Ex2),  $('#ex2')[0])
  ReactDOM.render(React.createElement(Link, page: "http://www.oracle.com", "ORACLE"), $('#link')[0])

