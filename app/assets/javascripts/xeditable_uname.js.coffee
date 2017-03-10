templateHtml = """
<div class='editable-uname'>
  <label>
    <span>Title: </span>
    <input type='text' name='title' class='input-small'>
  </label>
</div>
<div class='editable-uname'>
  <label>
    <span>First: * </span>
    <input type='text' name='first_name' class='input-small'>
  </label>
</div>
<div class='editable-uname'>
  <label>
    <span>Middle: </span>
    <input type='text' name='middle_name' class='input-mini'>
  </label>
</div>
<div class='editable-uname'>
  <label>
    <span>Last: * </span>
    <input type='text' name='last_name' class='input-mini'>
  </label>
</div>
<small style="font-size: 9pt;">* Required</small>
"""

blankTxt = (text)->
  text == undefined || text == ''

txtOut = (text)->
  return '' if blankTxt(text)
  "#{text} "

screenTxt = (obj)->
  """
  #{txtOut(obj.title)}#{txtOut(obj.first_name)}
  #{txtOut(obj.middle_name)}#{txtOut(obj.last_name)}
  """

(($) ->

  Uname = (options)-> @init "uname", options, Uname.defaults

  $.fn.editableutils.inherit Uname, $.fn.editabletypes.abstractinput

  $.extend Uname::,
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
      @$input.filter("[name=\"title\"]").val       value.title
      @$input.filter("[name=\"first_name\"]").val  value.first_name
      @$input.filter("[name=\"middle_name\"]").val value.middle_name
      @$input.filter("[name=\"last_name\"]").val   value.last_name

    # Returns value of input.
    input2value: ->
      title       : @$input.filter("[name=\"title\"]").val()
      first_name  : @$input.filter("[name=\"first_name\"]").val()
      middle_name : @$input.filter("[name=\"middle_name\"]").val()
      last_name   : @$input.filter("[name=\"last_name\"]").val()

    # Activates input: sets focus on the first field.
    activate: ->
      @$input.filter("[name=\"first_name\"]").focus()

    # Attaches handler to submit form in case of 'showbuttons=false' mode
    autosubmit: ->
      @$input.keydown (e) ->
        $(this).closest("form").submit()  if e.which is 13

  Uname.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults,
    tpl       : templateHtml
    inputclass: ""
  )
  $.fn.editabletypes.uname = Uname
) window.jQuery
