R = React.DOM

# Patch Bootstrap popover to take a React component instead of a
# plain HTML string

$.extend $.fn.popover.Constructor.DEFAULTS, react: false

oldSetContent = $.fn.popover.Constructor::setContent

$.fn.popover.Constructor::setContent = ->
  return oldSetContent.call(this) unless @options.react
  title   = @getTitle()      # must be a React Element!!
  content = @getContent()    # must be a React Element!!
  $tip    = @tip()
  $tip.removeClass 'fade top bottom left right in'
  unless $tip.find('.popover-content').html()      # don't rerender
    $title = $tip.find('.popover-title')
    if title                                       # render title, if any
      React.render title, $title[0]
    else
      $title.hide()
    React.render content, $tip.find('.popover-content')[0]


