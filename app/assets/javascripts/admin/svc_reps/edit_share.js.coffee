baseUrl = "/admin/svc_reps/#{lclData.reportId}"

setPickSelf = (val)->
  $.ajax
    type: 'put'
    data: {name: 'pick_self', value: val}
    url : baseUrl

processClick = (ev)->
  ev.preventDefault()
  $tgt = $(ev.target)
  if $tgt.hasClass('green')
    $tgt.removeClass('green').removeClass('fa-check-square-o')
        .addClass('fa-square-o')
    setPickSelf('false')
  else
    $tgt.removeClass('fa-square-o').addClass('green')
        .addClass('fa-check-square-o')
    setPickSelf('true')

$(document).ready ->
  $('.teamShare').click processClick