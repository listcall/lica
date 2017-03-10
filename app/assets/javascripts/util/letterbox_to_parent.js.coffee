# Letterbox Image to Parent Container

jQuery.fn.letterbox_to_parent = (options) ->
  defaults = parent: "div"                      # parent selector
  options  = jQuery.extend(defaults, options)   # optional selector over-ride
  @each ->
    elem = jQuery(this)
    parentWidth  = elem.parents(options.parent).width()
    parentHeight = elem.parents(options.parent).height()
    imageWidth   = elem.width()
    imageHeight  = elem.height()
    widthScale   = imageWidth / parentWidth
    scaleByWidth = (imageHeight / widthScale) < parentHeight
    newCss = if scaleByWidth
      { width: parentWidth, height: "auto"       }
    else
      { width: "auto",      height: parentHeight }
    elem.css newCss
  elem.trigger "load"  if @complete
