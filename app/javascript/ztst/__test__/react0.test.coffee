require("coffee-script/register")
React = require('react')
arg = require('../react0');

test 'arg presence', -> expect(arg).toBeDefined()
