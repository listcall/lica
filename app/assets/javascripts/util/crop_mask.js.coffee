#= require util/nat_size

# manages the mask position for photo cropping
class @CropMask

  # ----- private elements -----

  goldenRatio        = 1.61803
  landscapeExtraWide = (ctx)-> (ctx.elWidthP / ctx.elHeightP) > goldenRatio
  portraitExtraThin  = (ctx)-> (ctx.elHeightP / ctx.elWidthP) > goldenRatio

  # ----- properties -----

  constructor: (props = {}) ->
    @elP         = props.el
    @elHeightP   = props.elHeight   || props.el?.height()     || 0
    @elWidthP    = props.elWidth    || props.el?.width()      || 0
    @natHeightP  = props.natHeight  || @elP[0].naturalHeight  || 0
    @natWidthP   = props.natWidth   || @elP[0].naturalWidth   || 0
    @maskLayoutP = props.maskLayout || "square"   # square, portrait, landscape
    @maskHeightP = 75
    @maskTopP    = Math.round((@elHeightP  / 2) - (@maskHeightP / 2))
    @maskLeftP   = Math.round((@elWidthP / 2)   - (@width() / 2))
    @elRotationP = 0          # can be 0, 90, 180, 270

  # ----- public api -----

  heightMax: ->
    switch @maskLayoutP
      when "square"
        Math.min(@elHeightP, @elWidthP)
      when "landscape"
        if landscapeExtraWide(@)
          @elHeightP
        else
          Math.round(@elWidthP / goldenRatio)
      when "portrait"
        if portraitExtraThin(@)
          Math.round(@elHeightP / goldenRatio)
        else
          @elHeightP
  heightMin: -> Math.round(@heightMax() * .2)

  position: (newSettings = "")->
    opts = { top: @maskTopP, left: @maskLeftP }
    return opts if newSettings == ""
    @maskTopP  = newSettings.top
    @maskLeftP = newSettings.left
    @

  width: ->
    # maskWidth has no setters...
    switch @maskLayoutP
      when "square"    then @maskHeightP
      when "landscape" then Math.round(@maskHeightP * goldenRatio)
      when "portrait"  then Math.round(@maskHeightP / goldenRatio)

  height: (newHeight = "") ->
    return @maskHeightP if newHeight == ""
    maxH = @heightMax()
    minH = @heightMin()
    oldCenter = @maskCenter()
    @maskHeightP = newHeight
    @maskHeightP = maxH if (newHeight > maxH)
    @maskHeightP = minH if (newHeight < minH)
    @recenterMask(oldCenter)
    @

  rotateLeft:  -> @
  rotateRight: -> @

  layout: (newLayout = "")->
    return @maskLayoutP if newLayout = ""
    @maskLayoutP = newLayout
    @recenterMask()
    @
    
  maskCenter: ->
    top  = Math.round(@maskTopP  + (@maskHeightP/2))
    left = Math.round(@maskLeftP + (@width()/2))
    {top: top, left: left}
    
  elCenter: ->
    { top: Math.round(@elHeightP/2), left: Math.round(@elWidthP/2) }

  constrainMaskToEl: ->
    @maskTopP  = Math.min(@maskTopP,  @elHeightP - @maskHeightP)
    @maskTopP  = Math.max(@maskTopP,  0)
    @maskLeftP = Math.min(@maskLeftP, @elWidthP - @width())
    @maskLeftP = Math.max(@maskLeftP, 0)

  recenterMask: (centerPos = @elCenter())->
    @maskTopP  = centerPos.top  - Math.round((@maskHeightP / 2))
    @maskLeftP = centerPos.left - Math.round((@width() / 2))
    @constrainMaskToEl()

  naturalScale: -> @natHeightP / @elHeightP

  naturalMaskPosition: ->
    scale = @naturalScale()
    naturalTop  = Math.round(@maskTopP * scale)
    naturalLeft = Math.round(@maskLeftP * scale)
    { top: naturalTop, left: naturalLeft }

  naturalMaskHeight: -> Math.round(@maskHeightP * @naturalScale())

  naturalMaskWidth:  -> Math.round(@width() * @naturalScale())
