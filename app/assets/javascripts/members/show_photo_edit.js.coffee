#= require util/crop_mask

$.widget "vt.photo_edit",
  options:
    tbd: "NA"

  _create: (args)->
    @element.wrap("<div class='cropContainer' style='position: relative;' />");
    @mask    = new CropMask el: @element
    @cropDiv = $("<div class='cropMask' />");
    @element.before(@cropDiv);
    @element.parent().width(@element.width())
    @element.parent().height(@element.height())
    @cropDiv.draggable({containment: "parent"})
    @_setMaskPosition()
    @

  _setMaskPosition: ->
    pos = @mask.position()
    @cropDiv.css('top',    pos.top            )
    @cropDiv.css('left',   pos.left           )
    @cropDiv.css('height', @mask.height()     )
    @cropDiv.css('width',  @mask.width()      )

  reposition: ->
    @mask.position(@cropDiv.position())
    @

  maskData: ->
    pos = @mask.position()
    data = {
      top:    pos.top
      left:   pos.left
      height: @mask.height()
      width:  @mask.width()
    }
    data

  naturalData: ->
    pos = @mask.naturalMaskPosition()
    data = {
      top:    pos.top
      left:   pos.left
      height: @mask.naturalMaskHeight()
      width:  @mask.naturalMaskWidth()
    }
#    console.log "SCALE IS", @mask.naturalScale()
#    console.log "NATURAL DATA X", data
    data

  expandHeight: (increment)-> @height(@height() + increment); @
  shrinkHeight: (increment)-> @height(@height() - increment); @

  height: (newHeight = "")->
    return @mask.height() if newHeight == ""
    @mask.position(@cropDiv.position())
    @mask.height(newHeight)
    @_setMaskPosition()
    @
