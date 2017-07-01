RA = require("pgr/new_select/actions")
RS = {}

console.warn = ->

Util =
  closeModal       : ->
    $('#actionModal').modal('hide')
  saveAndCloseModal: ->
    @_updateDom()
    @closeModal()
  _updateDom: ->
    data = RS.selections.data
    periods = RS.periods
    if data.label_old == "NONE"
      $('#actionDisplay').empty()
    else
      selected    = RS.options.optionFor(data.label_old)
      periodInput = ->
        return "" unless selected.has_period
        periodName = "broadcast[action_attributes][period_id]"
        value = data.period_old
        title = periods.titleFor(value)
        label = periods.periodLabelFor(value)
        """
          <b>Event Title:</b> #{title}<br/>
          <b>Operational Period:</b> #{label}<br/>
          <input type='hidden' name='#{periodName}' value='#{value}'/>
        """
      typeName = "broadcast[action_attributes][type]"
      html = """
        <b>Selected Action:</b> #{selected.label}
        <input type='hidden' name='#{typeName}' value='#{selected.class_name}'/>
        <br/>
        #{periodInput()}
        <small><b>How it Works</b>: #{selected.about}</small>
      """
      $('#actionDisplay').html(html)

RS.util = Util

optionList = [
  {
    label: "NONE"
    about: "TBD"
    usage_ctxt: "there is no action to be performed"
  }
  {
    label: "RSVP"
    about: "TBD"
    usage_ctxt: "you invite people to join an event roster"
    has_period: true
  }
  {
    label: "LeaveHome"
    about: "TBD"
    usage_ctxt: "team members are leaving home for an event"
    has_period: true
  }
  {
    label: "ReturnHome"
    about: "TBD"
    usage_ctxt: "team members are returning home from an event"
    has_period: true
  }
]

periodList = [
  {
    event_id   : 1
    type_short : "T"
    type_long  : "Training"
    title_short: "Snow Ca..."
    title_long : "Snow Camping"
    start      : "Jan 4"
    periods    : [
      {
        label     : "OP1"
        period_id : 22
      }
    ]
  }
  {
    event_id   : 2
    type_short : "O"
    type_long  : "Operation"
    title_short: "Missing ..."
    title_long : "Missing Person Search"
    start      : "Jan 5"
    periods    : [
      { label: "OP1", period_id: 23 }
      { label: "OP2", period_id: 24 }
    ]
  }
  {
    event_id   : 3
    type_short : "M"
    type_long  : "General Meeting"
    title_short: "General M..."
    title_long : "General Meeting"
    start      : "Jan 6"
    periods    : [
      {
        label     : "OP1"
        period_id : 25
      }
    ]
  }
]

# ----- options store -----

RS.options = Reflux.createStore
  getInitialState: -> @data
  init       : -> @data = {optionList: window.OptionList || optionList}
  optionFor  : (lbl)-> _.find(@data.optionList, (opt)-> opt.label == lbl)
  reqdPeriod : (lbl)-> @optionFor(lbl)?.has_period

# ----- selections store -----

RS.selections = Reflux.createStore
  listenables: RA
  init: ->
    @data = {}
    @data.label_old = "NONE"
    @data.label_new = "NONE"
    @data.period_old = ""
    @data.period_new = ""
    @data.savable    = @savable()
  getInitialState: -> @data
  onOptionSelect: (option)->
    @data.label_new = option
    @data.savable    = @savable()
    @trigger(@data)
  onPeriodSelect: (period)->
    @data.period_new = period
    @data.savable    = @savable()
    @trigger(@data)
  onModalSave: ->
    @data.label_old = @data.label_new
    @data.period_old = @data.period_new
    @data.savable    = @savable()
    @trigger(@data)
    Util.saveAndCloseModal()
  onModalClose: ->
    @data.label_new = @data.label_old
    @data.period_new = @data.period_old
    @data.savable    = @savable()
    @trigger(@data)
    Util.closeModal()
  savable: ->
    return false if @_sameOption() && @_samePeriod()
    return false if @_sameOption() && @_optnPeriod()
    return false if @_nullPeriod() && @_reqdPeriod()
    return true  if @_diffOption()
    return true  if @_sameOption() && @_diffPeriod()
    return true  if @_diffOption() && @_diffPeriod()
    false
  _sameOption: -> @data.label_old == @data.label_new
  _diffOption: -> ! @_sameOption()
  _samePeriod: -> @data.period_old == @data.period_new
  _diffPeriod: -> ! @_samePeriod()
  _hasaPeriod: -> @data.period_new != ""
  _nullPeriod: -> ! @_hasaPeriod()
  _reqdPeriod: -> RS.options.reqdPeriod(@data.label_new)
  _optnPeriod: -> ! @_reqdPeriod()

# ----- period store -----

RS.periods = Reflux.createStore
  listenables     : RA
  init            : -> @data = {periodList: window.PeriodList || periodList}
  getInitialState : -> @data
  onPeriodUpdate  : (list)->
    return if typeof(list) == "undefined"
    @data.periodList = list
    @trigger(@data)
  eventFor        : (periodId)->
    _.find @data.periodList, (event)->
      _.some event.periods, (period)-> period.period_id == periodId
  titleFor        : (periodId)->
    return "" unless event = @eventFor(periodId)
    event.title_long
  periodLabelFor  : (periodId)->
    return "" unless event = @eventFor(periodId)
    period = _.find event.periods, (period)-> period.period_id == periodId
    return "" unless period
    period.label

# ----- utilities -----

module.exports = RS