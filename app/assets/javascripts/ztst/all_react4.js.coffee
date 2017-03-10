window.VT = {}

ReactDom = React
window.ReactDom = React

VT.Slide = require('ztst/react4_slide')
VT.Hello = require('ztst/react4_hello')

VT.TestComponent = React.createClass
  render: ->
    React.DOM.div {}, "Test Component"
