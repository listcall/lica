require("coffee-script/register")
const arg = require('../src2.coffee');

test('component keys', () => {
  expect(Object.keys(arg).length).toBe(2);
});

test('#bing with default component', () => {
  expect(arg.bing()).toBe("what");
});

test('#bing with component', () => {
  expect(arg.bing("fang")).toBe("fang");
});

test('addition', () => {
  expect(arg.sum(1,2)).toBe(3);
});

