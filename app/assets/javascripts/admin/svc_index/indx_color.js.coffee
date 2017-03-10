colors = {
  1: ["AC725E", "D06B64", "F83A22", "FA573C", "FF7537", "FFAD46"]
  2: ["42D692", "16A765", "7BD148", "B3DC6C", "FBE983", "FAD165"]
  3: ["92FFC0", "9FFFE7", "9FC6E7", "4986E7", "9A9CFF", "BA9AFF"]
  4: ["C2C2C2", "CABDBF", "CCA6AC", "F691B2", "CD74E6", "A47AE2"]
}

getTitle = ->
  $el = $(this)
  console.log "popover button", $el.attr('id'), $el.data('color')
  """
  <span class="text-info"><strong>Select Color</strong></span>
  """

selectBox = (color, current)->
  selected = if color == current then "grayBorder" else ""
  "<div class='colorBox #{selected}' data-color='#{color}' style='background: ##{color}'></div>"

getBody = ->
  $el = $(this)
  cur = $el.data('color')
  r1 = _.map(colors[1], (color)-> selectBox(color, cur)).join('')
  r2 = _.map(colors[2], (color)-> selectBox(color, cur)).join('')
  r3 = _.map(colors[3], (color)-> selectBox(color, cur)).join('')
  r4 = _.map(colors[4], (color)-> selectBox(color, cur)).join('')
  "#{r1}<br/>#{r2}<br/>#{r3}<br/>#{r4}<br/><small><a href='#' class='closePop'>cancel</a>"

closePops = (e)->
  $(".cPicker").each ->
    if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
      $(this).popover "hide"

$(document).ready ->
  $('.cPicker').popover
    html:      true
    title:     getTitle
    content:   getBody
    placement: 'right'
    container: 'body'

  $("body").on "click", (e) ->
    $(".cPicker").each ->
      if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
        $(this).popover "hide"

  $('.cPicker').on 'shown.bs.popover', ->
    $btn = $(this)
    $('.closePop').click (ev)->
      ev.preventDefault()
      $('.closePop').unbind()
      $('.cPicker').popover('hide');

    $('.colorBox').click (el)=>
      $box = $(el.target)
      btnId    = $btn[0].id.split('_')[1]
      newColor = $box.data('color')
      opts =
        name : 'label_color'
        value: newColor
      $.ajax
        url   : "/admin/svc_index/#{btnId}"
        data  : opts
        method: 'put'
        success: -> location.reload()
        failure: -> location.reload()