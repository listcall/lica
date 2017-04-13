arg = require('../pack1_a');

test 'component keys', -> expect(Object.keys(arg).length).toBe(1)

test 'msg', -> expect(arg.msg).toBe("this is pack1_a.js")
