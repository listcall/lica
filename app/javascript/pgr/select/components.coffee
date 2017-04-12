RA = require("pgr/select/actions")
RS = require("pgr/select/stores")
RC = {}             # React Components
RF = {}             # React Factories
D  = React.DOM

# <<<<< OPTION PANE >>>>>

# ----- OptionList -----

RC.OptionList = React.createClass
  mixins: [
    Reflux.connect RS.options   , "options"
    Reflux.connect RS.selections, "selections"
  ]
  render: ->
    D.div className: "btn-group-vertical", role: 'group',
        _.map @state.options.optionList, (option)=>
          altOpts = {key: option.label, option: @state.selections.label_new}
          RF.OptionItem _.merge(option, altOpts)

# ----- OptionItem -----

RC.OptionItem = React.createClass
  isSelected  : -> @props.option == @props.label
  notSelected : -> ! @isSelected()
  handleClick : -> RA.optionSelect(@props.label)
  render: ->
    classes = React.addons.classSet
      'btn'                      : true
      'active btn-info noPoint'  : @isSelected()
      'btn-default'              : @notSelected()
    D.button {ref: 'btn', className: classes, onClick: @handleClick}, @props.label

# <<<<< DISPLAY PANE >>>>>

# ----- OptionDisplay -----

RC.OptionDisplay = React.createClass
  mixins: [
    Reflux.connect RS.options   , "options"
    Reflux.connect RS.selections, "selections"
    Reflux.connect RS.periods   , "periods"
  ]
  render: ->
    D.div {},
      D.b {}, "Currently Selected: #{@state.selections.label_new}"
      D.p {}
      D.small {},
        if @state.selections.label_new == "NONE"
          RF.OptionTable @state
        else
          RF.OptionText @state

# ----- OptionTable -----

RC.OptionTable = React.createClass
  render: ->
    D.table { className: "table table-bordered table-condensed" },
      D.thead {},
        D.tr {},
          D.th {}, "Action"
          D.th {}, "Use When"
      D.tbody {},
        _.map @props.options.optionList, (option)=>
          D.tr { key: "rr_#{option.label}" },
            D.td {},
              if option.label == @props.selections.label_new
                option.label
              else
                D.a {href: '#', onClick: -> RA.optionSelect(option.label)}, option.label
            D.td {}, option.usage_ctxt

# ----- OptionText -----

RC.OptionText = React.createClass
  selectedOption : -> RS.options.optionFor(@props.selections.label_new)
  render: ->
    D.div {},
      D.b {}, "Use When: "
      @selectedOption().usage_ctxt
      D.p {}
      D.b {}, "How it works: "
      @selectedOption().about
      RF.PeriodSelect(@props) if @selectedOption().has_period

# ----- PeriodSelect -----

RC.PeriodSelect = React.createClass
  render: ->
    selectionProps = { selections: @props.selections }
    D.p {},
      D.table {className: 'table table-condensed table-bordered'},
        D.thead {},
          D.th {colSpan: 2}, "Event"
          D.th {}          , "Start"
          D.th {}          , "Select Period"      # <<<< need state
        D.tbody {},
          _.map @props.periods.periodList, (event)=>
            opts = _.merge({key: "e_#{event.event_id}"}, event, selectionProps)
            RF.PeriodEvent opts

RC.PeriodEvent = React.createClass
  render: ->
    selectionProps = { selections: @props.selections }
    D.tr {},
      D.td {}, @props.type_short
      D.td {}, @props.title_short
      D.td {}, @props.start
      D.td {},
        _.map @props.periods, (period)->
          opts = _.merge({key: "p_#{period.period_id}"}, period, selectionProps)
          RF.PeriodOp opts

RC.PeriodOp = React.createClass
  isSelected : ->
    return true if @props.selections.period_new == @props.period_id
    if @props.selections.period_new == ""
      return true if @props.selections.period_old == @props.period_id
    false
  notSelected : -> ! @isSelected()
  handleClick: ->
    RA.periodSelect(@props.period_id)
  render: ->
    classes = React.addons.classSet
      'btn btn-xs btn-ts'       : true
      'btn-info active noPoint' : @isSelected()
      'btn-default'             : @notSelected()
    opts = _.merge({className: classes}, {onClick: @handleClick})
    D.button opts, @props.label

# <<<<< BUTTONS >>>>>

RC.SaveButton = React.createClass
  mixins: [
    Reflux.connect RS.selections, "selections"
  ]
  handleClick: ->
    RA.modalSave()
  render: ->
    classes = React.addons.classSet
      'btn btn-sm btn-primary'    : true
      'disabled strikeout' : ! @state.selections.savable
    D.button {ref: 'btn', className: classes, type: 'button', onClick: @handleClick}, "Save"

RC.CloseButton = React.createClass
  handleClick: ->
    RA.modalClose()
  render: ->
    classes = 'btn btn-sm btn-default'
    D.button {ref: 'btn', className: classes, type: 'button', onClick: @handleClick}, "Close"

RC.TestButton = React.createClass
  mixins: [
    Reflux.connect RS.selections, "selections"
  ]
  handleClick: ->
    console.log "I WAS CALLED"
    "OK"
  render: ->
    D.button {ref:'tstBtn', onClick: @handleClick}, "Save"

_.each(_.keys(RC), (key)-> RF[key] = React.createFactory(RC[key]))

# ----- fini ------

module.exports = RC