htmlDecode = (input)->
  e = document.createElement('div')
  e.innerHTML = input;
  if e.childNodes.length == 0 then "" else e.childNodes[0].nodeValue

$(document).ready ->
  renderWidget = (col, type, idx) ->
    $.get "/api/widget/#{type}.json", (context)->
      template  = Handlebars.compile(htmlDecode(templates[type]))
      html      = template(context)
      $("#c#{col}_#{type}_#{idx}").html(html)
  renderC1 = (type, idx)-> renderWidget(1, type, idx+1)
  renderC2 = (type, idx)-> renderWidget(2, type, idx+1)
  _.each col1, renderC1
  _.each col2, renderC2