# test: javascripts/calculator2_spec

class @Calculator2
  add: (x, y)->
    x + y

# sample jquery plugin for testing
$.fn.setGreen = ->
  @each ->
    $(this).css('color', 'green')