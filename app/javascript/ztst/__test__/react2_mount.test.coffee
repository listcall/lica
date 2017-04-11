require("coffee-script/register")

window.React    = require("react")
window.ReactDOM = require("react-dom")

mod = require('../react2_mount');

test 'mod presence',  -> expect(mod).toBeDefined()

test 'component rendering', =>
  div = document.createElement('div')
  result = ReactDOM.render(mod.factory.App(), div)
  expect(result).toBeDefined()
