trunc = (string)->
  len = 9
  return string.substring(0,len-1)+'~' if (string.length > len)
  string

mailLink = (address)->
  return "" if address == "" || address == null
  if window.isPhone()
    "<button type='button' class='btn btn-xs'><a href='mailto:#{address}'>#{address}</a></button>"
  else
    "<a href='mailto:#{address}'>#{address}</a>"

phoneLink = (number)->
  return "" if number == "" || number == null
  if window.isPhone()
    snum = number.replace('-','')
    """
        <div class="btn-group">
          <button type="button" class='bbtn-r btn-xs'><a href='tel:#{snum}'>#{number}</a></button>
          <button type="button" class='bbtn-l btn-xs'><a href='sms:#{snum}'>SMS</a></button>
        </div>
      """
  else
    number

$(document).ready ->
  $('.emailDat').each ->
    adr = $(this).data('address')
    $(this).html(mailLink(adr))
  $('.phoneDat').each ->
    num = $(this).data('number')
    $(this).html(phoneLink(num))
