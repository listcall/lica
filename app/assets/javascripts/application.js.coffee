# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
## require jquery_ujs
#= require jquery.ui.all
#= require jquery-cookie
#= require modernizr
#= require lodash
#= require select2
#= require bootstrap/collapse
#= require bootstrap/tooltip
#= require bootstrap/popover
#= require bootstrap/modal
#= require bootstrap/dropdown
#= require bootstrap/alert
#= require bootstrap/tab
#= require bootstrap/button
#= require bootstrap-switch
#= require bootstrap3-editable/js/bootstrap-editable
#= require jquery.tablesorter
#= require jquery.tablesorter/jquery.tablesorter.widgets
#= require sweetalert
#= require react/react-with-addons
## require react_ujs
#= require react-bootstrap
#= require radium
#= require util/react_popover
#= require simulate-drag-sort
#= require jsn_bundle

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

$(window).load ->
  func = ->
    window.scrollTo 0, 1  if $(window).scrollTop() <= 0 and not location.hash
  setTimeout(func, 250)

