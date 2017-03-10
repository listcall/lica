window.resetTooltips = ($el, data)->
  $el.tooltip('destroy')
  $el.tooltip(data)

window.resetVisibleTooltips = ->
  return if touchDevice
  resetTooltips $('.visible'), {title: "toggle visibility"}

window.resetPagableTooltips = ->
  return if touchDevice
  resetTooltips $('.pagable'),            {title: "toggle pagability"}
  resetTooltips $('.pagable-restricted'), {title: "not pagable"}
  resetTooltips $('.pagable-view').find('.green_phone'), {title: "phone is pagable"}
  resetTooltips $('.pagable-view').find('.red_phone')  , {title: "phone is not pagable"}
  resetTooltips $('.pagable-view').find('.green_email'), {title: "email is pagable"}
  resetTooltips $('.pagable-view').find('.red_email')  , {title: "email is not pagable"}

$(document).ready ->
  resetVisibleTooltips()
  resetPagableTooltips()