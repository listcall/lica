// I found it simpler to use coffee-react,
// since it does the jsx transform and coffeescript compilation 
var coffee = require('coffee-script');

module.exports = {
  process: function(src, path) {
    if (path.match(/\.coffee$/)) {
      return coffee.compile(src, {bare: true});
    }
    return src;
  }
};
