templateHtml = """
<div class='editable-contact'>
  <label>
    <span>Name: * </span>
    <input type='text' name='name' class='input-small'>
  </label>
</div>
<div class='editable-contact'>
  <label>
    <span>Kinship: </span>
    <input type='text' name='kinship' class='input-small' placeholder="Spouse, Friend, etc.">
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
  if obj.kinship == undefined || obj.kinship == ""
    txtOut(obj.name)
  else
    "#{txtOut(obj.name)} / #{txtOut(obj.kinship)}"

(($) ->
  Contact = (options)-> @init "contact", options, Contact.defaults
  $.fn.editableutils.inherit Contact, $.fn.editabletypes.abstractinput
  $.extend Contact::,
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
      @$input.filter("[name=\"name\"]").val     value.name
      @$input.filter("[name=\"kinship\"]").val  value.kinship

    # Returns value of input.
    input2value: ->
      name     : @$input.filter("[name=\"name\"]").val()
      kinship  : @$input.filter("[name=\"kinship\"]").val()

    # Activates input: sets focus on the first field.
    activate: ->
      @$input.filter("[name=\"name\"]").focus()

    # Attaches handler to submit form in case of 'showbuttons=false' mode
    autosubmit: ->
      @$input.keydown (e) ->
        $(this).closest("form").submit()  if e.which is 13

  Contact.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults,
    tpl       : templateHtml
    inputclass: ""
  )
  $.fn.editabletypes.contact = Contact
) window.jQuery
