templateHtml = """
<div class='editable-address'>
  <label>
    <span>Address1: </span>
    <input type='text' name='address1' class='input-small'>
  </label>
</div>
<div class='editable-address'>
  <label>
    <span>Address2: </span>
    <input type='text' name='address2' class='input-small'>
  </label>
</div>
<div class='editable-address'>
  <label>
    <span>City: </span>
    <input type='text' name='city' class='input-mini'>
  </label>
</div>
<div class='editable-address'>
  <label>
    <span>State: </span>
    <input type='text' name='state' class='input-mini' placeholder="use 2-letter abbreviation">
  </label>
</div>
<div class='editable-address'>
  <label>
    <span>Zip: * </span>
    <input type='text' name='zip' class='input-mini'>
  </label>
</div>
<small>* Required</small>
"""

blankTxt = (text)->
  text == undefined || text == ''

txtCom = (text)->
  return '' if blankTxt(text)
  "#{text}, "

txtOut = (text)->
  return '' if blankTxt(text)
  "#{text} "

screenTxt = (obj)->
  """
  #{txtCom(obj.address1)}#{txtCom(obj.address2)}
  #{txtOut(obj.city)}#{txtOut(obj.state)} #{txtOut(obj.zip)}
  """

(($) ->

  Address = (options)-> @init "address", options, Address.defaults

  $.fn.editableutils.inherit Address, $.fn.editabletypes.abstractinput

  $.extend Address::,
    # renders input from Tpl
    render: ->
      @$input = @$tpl.find("input")

    # Default method to show value in element. Can be overwritten by display option.
    value2html: (value, element) ->
      unless value
        $(element).empty()
        return
      $(element).html screenTxt(value)

    # Gets value from element's html - don't use this
    html2value: (html)-> null

    # Converts value to string - used in internal comparing (not for sending to server).
    value2str: (value) ->
      str = ""
      if value
        for k of value
          str = str + k + ":" + value[k] + ";"
      str

    # Converts string to value. Used for reading value from 'data-value' attribute.
    str2value: (str) -> str

    # Sets value of input.
    value2input: (value) ->
      return unless value
      @$input.filter("[name=\"address1\"]").val value.address1
      @$input.filter("[name=\"address2\"]").val value.address2
      @$input.filter("[name=\"city\"]").val     value.city
      @$input.filter("[name=\"state\"]").val    value.state
      @$input.filter("[name=\"zip\"]").val      value.zip

    # Returns value of input.
    input2value: ->
      address1: @$input.filter("[name=\"address1\"]").val()
      address2: @$input.filter("[name=\"address2\"]").val()
      city    : @$input.filter("[name=\"city\"]").val()
      state   : @$input.filter("[name=\"state\"]").val()
      zip     : @$input.filter("[name=\"zip\"]").val()

    # Activates input: sets focus on the first field.
    activate: ->
      @$input.filter("[name=\"address1\"]").focus()

    # Attaches handler to submit form in case of 'showbuttons=false' mode
    autosubmit: ->
      @$input.keydown (e) ->
        $(this).closest("form").submit()  if e.which is 13

  Address.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults,
    tpl       : templateHtml
    inputclass: ""
  )
  $.fn.editabletypes.address = Address
) window.jQuery

