require("coffee-script/register")

window.React    = require("react")
window.ReactDOM = require("react-dom")
window._        = require("lodash")

coms = require('../react1');

test 'obj presence',  -> expect(coms).toBeDefined()
test 'com1 presence', -> expect(coms.hello).toBeDefined()
test 'com2 presence', -> expect(coms.typeAhead).toBeDefined()

test 'com1 rendering', =>
  div = document.createElement('div')
  result = ReactDOM.render(coms.hello(), div)
  expect(result).toBeDefined()

test 'com2 rendering', =>
  div = document.createElement('div')
  result = ReactDOM.render(React.createElement(coms.typeAhead), div)
  expect(result).toBeDefined()
