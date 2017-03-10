# Get natural width for already-loaded images
## require jquery

jQuery.fn.natWidth = ->
  return @[0].naturalWidth if (new Image).hasOwnProperty('naturalWidth')
  @width

jQuery.fn.natHeight = ->
  return @[0].naturalHeight if (new Image).hasOwnProperty('naturalHeight')
  @height()