#= require ./date_change

startOfYear = -> "#{moment().year()}-01-01"
today       = -> display(moment())
threeMos    = -> display(moment().subtract('months', 3))
sixMos      = -> display(moment().subtract('months', 6))
twelveMos   = -> display(moment().subtract('months', 12))

display = (date)->
  date.format("YYYY-MM-DD")
  
fadeTime = 1500

dispYTD = (type)->
  $("##{type}_start").val(startOfYear()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  $("##{type}_finish").val(today()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  update_link_for(type)

disp12m = (type)->
  $("##{type}_start").val(twelveMos()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  $("##{type}_finish").val(today()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  update_link_for(type)

disp6m = (type)->
  $("##{type}_start").val(sixMos()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  $("##{type}_finish").val(today()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  update_link_for(type)

disp3m = (type)->
  $("##{type}_start").val(threeMos()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  $("##{type}_finish").val(today()).css('backgroundColor', 'yellow').animate({backgroundColor: '#fff'}, fadeTime)
  update_link_for(type)

getType = (event)->
  event.target.id.split('_')[0]

$(document).ready ->
  $('.faYTD').tooltip({title: "year-to-date"})
  $('.fa12m').tooltip({title: "prior year"})
  $('.fa6m').tooltip({title:  "prior six months"})
  $('.fa3m').tooltip({title:  "prior three months"})

  $('.faYTD').click (ev)-> dispYTD(getType(ev))
  $('.fa12m').click (ev)-> disp12m(getType(ev))
  $('.fa6m').click  (ev)-> disp6m(getType(ev))
  $('.fa3m').click  (ev)-> disp3m(getType(ev))
