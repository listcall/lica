# old_serv

has_substring = (string, sub)->
  string.indexOf(sub) != -1

updateVisibility = (e, params)->
  schedType = params?.newValue || $('#schedType').text()
  if has_substring(schedType, "rotation")
    $('#rotationType').show()
  else
    $('#rotationType').hide()
  if schedType == 'weekly_rotation'
    $('.wkly').show()
    $('.adhc').hide()
  else
    $('.adhc').show()
    $('.wkly').hide()

$(document).ready ->
  $('button.wkly').css('border-top-left-radius', "4px").css('border-bottom-left-radius', "4px")
  updateVisibility()
  $('#schedType').on 'save', updateVisibility
