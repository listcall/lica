updateNav = (element)->
  typ = $(element).data('typ')
  $('.pn').each (idx, el)->
    $el = $(el)
    old_href = $el.attr('href')
    new_href = old_href.replace(/tab=.*/,"tab=#{typ}")
    $el.attr('href', new_href)

$(document).ready ->
  $('#navTab a').click (e)->
    e.preventDefault()
    updateNav(this)
    $(this).tab('show')