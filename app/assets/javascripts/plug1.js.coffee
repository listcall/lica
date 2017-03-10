# A class-based template for jQuery plugins in Coffeescript
#
#     $('.target').myPlugin({ paramA: 'not-foo' });
#     $('.target').myPlugin('myMethod', 'Hello, world');
#

$ = jQuery

# plugin class
class MyPlugin

  defaults:
    paramA: 'foo'
    paramB: 'bar'

  constructor: (el, options) ->
    @options = $.extend({}, @defaults, options)
    @$el = $(el)

  # Additional plugin methods go here
  myMethod: (echo) ->
    @$el.html(@options.paramA + ': ' + echo)

pName = 'myPlugin'
pKlas = MyPlugin

# plugin
$.fn[pName] = (option, args...) ->
  @each ->
    $this = $(this)
    obj = $this.data(pName)
    if !obj
      obj = new pKlas(this, option)
      $this.data pName, obj
    if typeof option == 'string'
      obj[option].apply(obj, args)
