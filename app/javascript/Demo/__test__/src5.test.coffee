require("coffee-script/register")
arg = require('../src2')

describe "something nice", ->
  test 'arg keys', -> expect(Object.keys(arg).length).toBe(2)
  test '#bing with default arg', -> expect(arg.bing()).toBe("what")

describe "something else", ->
  test '#bing with arg', -> expect(arg.bing("fang")).toBe("fang")

describe "when doing something", ->
  test 'addition', -> expect(arg.sum(1,2)).toBe(3)

