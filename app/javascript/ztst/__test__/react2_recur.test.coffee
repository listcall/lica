require("coffee-script/register")

window.React    = require("react")
window.ReactDOM = require("react-dom")

mod = require('../react2_recur');

test 'mod presence',  -> expect(mod).toBeDefined()
test 'mod hello',  -> expect(mod.hello).toBeDefined()
test 'mod recur',  -> expect(mod.factory).toBeDefined()

test 'component rendering 1', =>
  div = document.createElement('div')
  result = ReactDOM.render(mod.factory.App(), div)
  expect(result).toBeDefined()

test 'component rendering 2', =>
  div = document.createElement('div')
  result = ReactDOM.render(mod.hello(), div)
  expect(result).toBeDefined()
