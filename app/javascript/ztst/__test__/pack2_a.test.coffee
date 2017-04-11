require("coffee-script/register")
arg = require('../pack2_a');

test 'component keys', -> expect(Object.keys(arg).length).toBe(1)

test 'msg', -> expect(arg.msg).toBe("this is pack2_a.coffee")


