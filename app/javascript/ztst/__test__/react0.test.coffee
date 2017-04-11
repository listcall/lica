require("coffee-script/register")
window.React    = require("react")
window.ReactDOM = require("react-dom")
component = require('../react0');

test 'component presence', -> expect(component).toBeDefined()

test 'component rendering with ReactDOM', =>
  div = document.createElement('div')
  result = ReactDOM.render(component(), div)
  expect(result).toBeDefined()
