// This file processes coffeescript files in jest testing.
// Review the package.json file for configuration info.

var coffee = require('coffee-script');

module.exports = {
  process: function (src, path) {
    if (path.match(/\.coffee$/)) {
      return coffee.compile(src, {bare: true});
    }
    return src;
  }
};
