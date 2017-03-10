
$(document).ready ->
  $('.clkToggle').css('color', "#2a6496")
  $('.clkToggle').click (ev)->
    ev.preventDefault()
    $tgt = $(ev.target)
    tgtId = $tgt.attr("href")
    $('.collapse').collapse('hide')
    $(tgtId).collapse('show')
    $('.clkToggle').css('color', "#2a6496")
    $tgt.css('color', 'black')