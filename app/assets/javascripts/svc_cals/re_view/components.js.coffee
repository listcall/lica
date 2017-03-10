RA = require("svc_cals/re_view/actions")
RS = require("svc_cals/re_view/stores")
RC = {}          # React components
RF = {}          # React factories
RE = {}          # React elements
BC = ReactBootstrap
BF = {}          # ReactBootstrap factories
D  = React.DOM   # React DOM

_.each(_.keys(BC), (key)-> BF[key] = React.createFactory(BC[key]))

key.filter = (ev)->
  return true unless _.include([37,38,39,40], ev.which) # filter arrow keys
  tagName = (event.target || event.srcElement).tagName
  return false if tagName == 'INPUT'                    # filter on INPUT field
  true

window.RS = RS

selectedStyle = { color: 'black', textDecoration: 'underline' }

RC.Spacer = React.createClass
  displayName: "Spacer"
  render: -> D.span {style: {display: 'inline-block', width: '12px'}}

RC.NullSpace = React.createClass
  render: -> D.span {style: {display: 'inline-block'}}

# <<<<< SHARED State >>>>>

StateMixin =
  numEvents  : -> @props.grid.cursor.events()?.length || 0
  validTime  : -> @props.form.validTime
  statusOff  : -> @props.grid.cursor.cell?.isUnavail()
  statusOn   : -> @props.grid.cursor.cell?.isAvail()
  modeIs     : (modes...)-> _.includes modes, @props.form.newMode
  modeIsNot  : (modes...)-> ! @modeIs(modes...)
  showNew    : -> lclData.editable && @modeIs('null', 'base') && @statusOn()
  showCreate : -> lclData.editable && @modeIs('nullNew', 'baseNew') && @validTime()
  showUpdate : -> lclData.editable && @modeIs('baseEdit') && @validTime()
  showDelete : -> lclData.editable && @modeIs('base') && @statusOn()
  showCancel : -> lclData.editable && @modeIs('baseNew', 'baseEdit', 'nullNew')
  showCycle  : -> lclData.editable && @modeIs('base') && @numEvents() > 1
  showSignIn : -> lclData.editable && @statusOff()
  showSignOut: -> lclData.editable && @modeIs('base', 'null') && @statusOn()
  showEl     : -> lclData.editable && (@numEvents() > 0 || @modeIsNot('null')) && @statusOn()
  hideEl     : -> ! @showEl()

# <<<<< RESOURCE TABLE >>>>>

RC.ResTable = React.createClass
  displayName: "Table"
  mixins    : [Reflux.connect(RS.grid, "grid"), Reflux.connect(RS.form, "form")]
  componentWillMount       : -> RS.grid.setup(@props.start)
  componentWillReceiveProps: (nextProps)->
    nextStart = nextProps.start
    RS.grid.setup(nextStart) if nextStart? && nextStart != @props.start
  render: ->
    tStyle = {tableLayout: 'fixed', whiteSpace: 'nowrap'}
    childProps = _.extend(@state, {start: @props.start?.clone()})
#    return D.div {} if _.isEmpty(@state.grid.rows.list)
    D.div {},
      RF.ResKey childProps
      D.table {className: 'res', style: tStyle},
        RF.ResHdr  childProps
        RF.ResBody childProps

# ----- KEYBOARD HANDLER -----

RC.ResKey = React.createClass
  mixins: [StateMixin]
  arrowKeys : "left, right, up, down"
  escKey    : "esc, escape"
  newKey    : "alt+n"
  saveKey   : "alt+s"
  updateKey : "alt+s"
  deleteKey : "alt+d"
  cycleKey  : "alt+c"
  filterKey : "alt+f"
  keyEx     : (keyDef, action, condition = true)->
    key.unbind(keyDef)
    return unless condition
    key(keyDef, (ev)-> ev.preventDefault(); action(ev))
  keyUpdate : ->
    @keyEx @escKey    , ((ev)-> RA.btnCancel(@props)) , @showCancel()
    @keyEx @newKey    , ((ev)-> RA.btnNew(@props))    , @showNew()
    @keyEx @cycleKey  , ((ev)-> RA.btnCycle(@props))  , @showCycle()
    @keyEx @updateKey , ((ev)-> RA.btnUpdate(@props)) , @showUpdate()
    @keyEx @deleteKey , ((ev)-> RA.btnDelete(@props)) , @showDelete()
  componentDidMount : ->
    @keyEx @arrowKeys, ((ev)-> RA.cellArrowKey(ev))
    @keyUpdate()
  componentWillUpdate: ->
    @keyUpdate()
  render: ->
    D.div {}

# ----- RESOURCE HEADER -----

RC.ResHdr = React.createClass
  displayName: "Hdr"
  render: ->
    D.thead {className: 'fc-head'},
      RF.ResHdrBar   @props
      RF.ResHdrDates @props

# ----- Header Bar -----

RC.ResHdrBar = React.createClass
  displayName: "HdrBar"
  render: ->
    imgStyle =
      paddingLeft : 3
      paddingRight: 3
      marginTop   : 3
    imgUrl = @props.grid.cursor.avatarUrl()
    D.tr {style: {background: '#DDD', height: 28}},
      D.td {colSpan: 2, style: {overflow: 'hidden'}},
        if @props.grid.cursor.hasRows()
          D.img {style: imgStyle, src: imgUrl, className: 'icon'}
        D.small {}, @props.grid.cursor.label()
      D.td {colSpan: 5},
        RF.ResHdrInput  _.extend(@props, @state, {hModTime: @hModTime})
        RF.Spacer {}
        RF.ResHdrSelect _.extend(@props, @state)
        RF.Spacer {}
        RF.ResHdrRepeat @props
      D.td {},
        RF.ResHdrButtons @props

RC.ResHdrInput = React.createClass
  displayName: "HdrInput"
  mixins  : [StateMixin]
  setFocus: ->
    return unless @props.form.newFocus == 'input'
    $el = $(@getDOMNode()).find('input')
    $el.focus()
    input = $el[0]
    return if input == undefined
    len = $el[0].value.length
    $el[0].setSelectionRange(len, len)
  componentDidMount : ->
    @setFocus()
  componentDidUpdate: ->
    @setFocus()
    return if isNaN(@caret)
    node = $(@getDOMNode()).find('input')[0]
    node.setSelectionRange(@caret, @caret) if node? && @caret?
  handleMod        : (ev)->
    tgt    = event.target
    src    = tgt.value
    @caret = tgt.selectionStart
    RA.modTime(src)
  render           : ->
    return D.span({}) if @hideEl()
    hndlr = { onChange: @handleMod }
    style = { style: {width: 72, height: 6, display: 'inline', paddingLeft: 2} }
    base  = { className: 'form-control input-sm has-error', type: 'text' }
    opts  = { value: @props.form.newTime }
    dSty  = { height: 6, display: 'inline-block' }
    err   = if @props.form.validTime then "" else "has-error"
    D.div {className: "form-group #{err}", style: dSty},
      D.input _.extend(base, opts, style, hndlr)

RC.ResHdrSelect = React.createClass
  displayName: "HdrSelect"
  mixins     : [StateMixin]
  render: ->
    return D.span({}) if @hideEl()
    args = {onChange: (ev)-> RA.modService(ev.target.value)}
    D.select _.extend({value: @props.form.newSvc}, args),
      _.map lclData.svcList, (svc)-> D.option {value: svc.id}, svc.name

RC.ResHdrRepeat = React.createClass
  displayName: "HdrRepeat"
  mixins     : [StateMixin]
  domNode: -> $(@getDOMNode())
  closePopovers: (e)->
    $node = @domNode()
    notTarget = not $node.is(e.target)
    noTargets = $node.has(e.target).length is 0
    noPopTgts = $(".popover").has(e.target).length is 0
    closable  = notTarget and noTargets and noPopTgts
    $node.popover "hide" if closable
  setupPopover: ->
    args =
      html      : true
      placement : 'bottom'
      content   : -> "<div class='repeatBody'>Loading...</div>"
    $node = @domNode()
    $node.popover('destroy').popover(args)
    $node.on 'shown.bs.popover', =>
      rule = @props.form.newRule
      comp = RF.ResRecPck {handleClose: @handleClose, handleOk: @handleOk, rule: rule}
      React.render comp, $('.repeatBody')[0]
    $("body").unbind().on "click", (ev)=> @closePopovers(ev)
  componentDidMount : -> @setupPopover()
  componentDidUpdate: -> @setupPopover()
  handleClose:        -> @domNode().popover('hide')
  handleOk:           -> RA.modRepeat(resourcePicker.toHash())
  ruleType   :        ->
    string = @props.form.newRule?.rule_type || "Never"
    return "Never"   if string == "Never"
    return "Daily"   if string.match(/Daily/)
    return "Weekly"  if string.match(/Weekly/)
    return "Monthly" if string.match(/Monthly/)
    return "Never"
  render: ->
    return D.span({}) if @hideEl()  || @props.grid.rows.list.length == 0
    D.a {href: '#'}, D.small {}, "Repeats #{@ruleType()}"

RC.ResRecPck = React.createClass
  render: ->
    comp = React.createElement RC.RecurPicker, {rule: @props.rule, form: true}
    D.div {},
      comp
      D.div {className: "ar", style: {width: 250}},
        D.small {},
          D.a {href: '#', onClick: @props.handleOk}, "ok"
          " | "
          D.a {href: '#', onClick: @props.handleClose}, "cancel"

RC.ResHdrButtons = React.createClass
  displayName: "HdrButtons"
  mixins     : [StateMixin]
  iBtn  : (klas, action, tip)->
    args =
      btnKlas    : klas
      btnAction  : action
      btnTip     : tip
    RF.ResHdrBtn _.extend args, @props
  render: ->
    list = _.without [
      @iBtn('sbNew'    , RA.btnNew    , "New"         )   if @showNew()
      @iBtn('sbCreate' , RA.btnCreate , "Save"        )   if @showCreate()
      @iBtn('sbUpdate' , RA.btnUpdate , "Update"      )   if @showUpdate()
      RF.NullSpace {}
      @iBtn('sbDelete' , RA.btnDelete , "Delete"      )   if @showDelete()
      @iBtn('sbCancel' , RA.btnCancel , "Cancel"      )   if @showCancel()
      @iBtn('sbCycle'  , RA.btnCycle  , "Next Event"  )   if @showCycle()
      @iBtn('sbSignIn' , RA.btnSignIn , "SignIn"      )   if @showSignIn()
      @iBtn('sbSignOut', RA.btnSignOut, "SignOut"     )   if @showSignOut()
    ], undefined
    D.div {}, list

RC.ResHdrBtn = React.createClass
  componentDidMount   : -> $(@getDOMNode()).tooltip()
  componentDidUpdate  : -> $(@getDOMNode()).tooltip('destroy').tooltip()
  componentWillUnmount: -> $(@getDOMNode()).tooltip('destroy')
  render: ->
    argA =
      dataPlacement: "top"
      title        : @props.btnTip
      href         : '#'
      onClick      : => @props.btnAction(@props)
    argI =
      className    : @props.btnKlas
    D.a argA, D.i argI

# ----- Header Dates -----

RC.ResHdrDates = React.createClass
  displayName: "HdrDates"
  render: ->
    thStyleN = {}
    thStyleS = {background: '#fcf8e3'}
    today = moment().format("ddd M/D")
    D.tr {},
      RF.ResNameSearch {}
      _.map [0..6], (idx)=>
        colDate = @props.grid.dates[idx]
        colKlas = if today == colDate then 'today' else ''
        colKlas = if idx == @props.grid.cursor.col then 'selectedHdr' else colKlas
        D.th {className: colKlas}, RF.ResColDate(_.extend(@props, {col: idx}))

RC.ResNameSearch = React.createClass
  handleChange: (newVal)->
    RA.updateFilter(newVal)
    @setState {filterText: newVal}
  handleClear: (ev)->
    ev.preventDefault()
    @handleChange('')
    @refs.filterBox.getDOMNode().focus()
  getInitialState: -> {filterText: ""}
  hasFilterText  : -> @state.filterText.length > 0
  inputArgs: ->
    result =
      onChange : (ev)=> @handleChange(ev.target.value)
      style:
        width        : 80
        borderRadius : 4
        borderWidth  : 1
      ref: 'filterBox'
      value : @state.filterText
  render: ->
    D.th {},
      D.small {},
        D.input @inputArgs(),
        RF.ResNameButton _.extend(@state, {handleClear: @handleClear})

RC.ResNameButton = React.createClass
  iconArgs: ->
    type   = if @props.filterText == "" then "search" else "times-circle redX"
    result =
      className : "fa fa-#{type}"
      style     : {paddingLeft: 5, paddingRight: 5}
  render: ->
    D.a {href: '#', onClick: (ev)=> @props.handleClear(ev)},
      D.i @iconArgs()

RC.ResColDate = React.createClass
  mixins: [Radium.StyleResolverMixin]
  render: ->
    styles =
      paddingLeft : 1
      paddingRight: 1
      modifiers: [{kind:{selected: selectedStyle}}]
    @props.kind = 'selected' if @props.col == @props.grid.cursor.col
    D.small {style: @buildStyles(styles)}, @props.grid.dates[@props.col]

# ----- RESOURCE BODY -----

RC.ResBody = React.createClass
  displayName: "Body"
  render: ->
    startHeight = window.innerHeight - 250
    D.tbody {className: 'fc-body', style: {height: startHeight}},
      _.map @props.grid.rows.list, (row)=>
        RF.ResRow(_.extend(@props, {row: row}))

# ----- RESOURCE ROW -----

RC.ResRow = React.createClass
  render   : ->
    lblKlas = if @props.row.isSelected() then "selectedHdr" else ""
    D.tr {},
      D.td {className: lblKlas},
        RF.ResRowName @props
      _.map @props.row.cells, (cell)=>
        opts = _.extend(@props, {cell: cell})
        RF.ResCell opts

RC.ResRowName = React.createClass
  mixins: [Radium.StyleResolverMixin]
  componentDidMount   : -> $(@getDOMNode()).tooltip({placement: "left"})
  componentDidUpdate  : -> $(@getDOMNode()).tooltip('destroy').tooltip({placement: "left"})
  componentWillUnmount: -> $(@getDOMNode()).tooltip('destroy')
  render: ->
    styles =
      modifiers   : [{kind:{selected: selectedStyle}}]
      paddingLeft : 2
      paddingRight: 2
    [first, last] = [@props.row.memFirst, @props.row.memLast]
    @props.kind = 'selected' if @props.row.isSelected()
    uid = @props.row.rowData.member.user_name
    args =
      href         : "/members/#{uid}"
      target       : "_blank"
      title        : @props.row.memName
      className    : "memLinkz"
    D.a args,
      D.small {style: @buildStyles(styles)}, "#{first.charAt(0)}. #{last}"

# ----- RESOURCE CELL -----

RC.ResCell = React.createClass
  opts: ->
    select = @props.cell.selectKlas()
    today  = @props.cell.todayKlas()
    {
    ref      : @props.cell.cellRef
    onClick  : => RA.cellClick @props.cell.cellRef
    className: "fc-event-container #{today} #{select}"
    }
  eventIsCurrent: (idx)->
    return false if @props.grid.cursor.position != @props.cell.cellRef
    idx == @props.form.newIdx
  render: ->
    return D.td(_.extend(@opts(),{style: {textAlign: 'center'}}), "OFF") if @props.cell.isUnavail()
    return D.td(@opts()) unless @props.cell.hasEvents()
    D.td @opts(),
      _.map @props.cell.events, (event, index)=>
        ext = {event, event}
        ext.kind = ""
        ext.kind = "selected" if @eventIsCurrent(index)
        RF.ResEvent _.extend(@props, ext, {idx: index})

RC.ResEvent = React.createClass
  mixins: [Radium.StyleResolverMixin]
  opts: ->
    {
    style    : {backgroundColor: @props.event.backgroundColor, color: '#000000'}
    className: 'fc-day-grid-event fc-h-event fc-event fc-start fc-end'
    onClick  : (ev)=>
      ev.stopPropagation()
      RA.eventClick @props.cell.cellRef, @props.idx
    }
  render: ->
    styles =
      cursor   : 'pointer'
      modifiers: [{kind:{selected: selectedStyle}}]
    spanStyles = {className: 'fc-time', style: @buildStyles(styles)}
    D.a @opts(),
      D.div  {className: 'fc-content'}
      D.span spanStyles, @props.event.timeStr

# ---- TIME PICKER -----
RC.TimePicker = React.createClass
  getInitialState: ->
    obj = {}
    obj.start  = @props?.start  || 12
    obj.finish = @props?.finish || 15
    obj
  updateState: (newState) ->
    obj = {
      start   : newState.start
      finish  : newState.finish
    }
    @setState obj
  setFocus: ->
    $el = $(@getDOMNode()).find('input')
    $el.focus()
    input = $el[0]
    return if input == undefined
    len = $el[0].value.length
    $el[0].setSelectionRange(len, len)
  handleMod: (ev)->
    tgt = event.target
    src = tgt.value.split('-')
    @setState(start: src[0], finish: src[1])
  normalize: (string)->
    parts = string.split(':')
    "#{parts[0]}:#{parts[1] || '00'}"
  toHash: ->
    { start: @normalize(@state.start), finish: @normalize(@state.finish) }
  componentDidMount: ->
    @setFocus()
  componentDidUpdate: ->
    @setFocus()
  render: ->
    bas = { ref: 'timeInput', type: 'text'               }
    hnd = { onChange: @handleMod                         }
    val = { value: "#{@state.start}-#{@state.finish}"    }
    sty = { style: { width: "85px", marginLeft: "10px" } }
    D.div {},
      D.p  {}
      D.b  {}, "Start-Finish:"
      D.input _.extend bas, hnd, val, sty

# ----- RECUR PICKER -----

RC.RecurPicker = React.createClass
  getDefaultProps: -> rule : {}
  getInitialState: ->
    obj = @props.rule
    obj.ends = "Never"
    obj.ends = "After" if obj.count
    obj.ends = "On"    if obj.until
    obj.rule_type ?= "Never"
    obj.interval  ?= 1
    obj.count     ?= 1
    obj.until     ?= "2015-06-01"
    obj
  resetState: ->
    obj =
      rule_type : "Never"
      interval  :  1
      ends      : "Never"
      count     : 1
      until     : "2014-09-01"
    @updateState(obj)
  updateState: (newState) ->
    obj = {
      rule_type : newState.rule_type
      interval  : newState.interval
      ends      : "Never"
    }
    if newState.count
      obj.count = newState.count
      obj.ends  = "After"
    else
      if newState.until
        obj.until = newState.until
        obj.ends  = "On"
    @setState obj
  componentDidMount : -> window.resourcePicker = this
  toHash: ->
    obj = {
      rule_type : @state.rule_type
      interval  : @state.interval
    }
    switch @state.ends
      when "After" then obj.count = @state.count
      when "On"    then obj.until = @state.until
    obj
  updateRuleType: ->
    @setState rule_type: @refs.ruleType.getDOMNode().value
  updateInterval: ->
    num = parseInt(@refs.interval.getDOMNode().value)
    num = 1 if isNaN(num) || num < 1
    @setState interval: num
  updateUntil: ->
    @setState until: @refs.until.getDOMNode().value
  updateCount: ->
    num = parseInt(@refs.count.getDOMNode().value)
    num = 1 if isNaN(num) || num < 1
    @setState count: num
  setNever   : -> @setState ends: "Never"
  setAfter   : -> @setState ends: "After"
  setOn      : -> @setState ends: "On"
  endsNever  : -> @state.ends == "Never"
  endsAfter  : -> @state.ends == "After"
  endsOn     : -> @state.ends == "On"
  intervalLabel: ->
    word = switch @state.rule_type
      when "IceCube::DailyRule"    then "day"
      when "IceCube::WeeklyRule"   then "week"
      when "IceCube::MonthlyRule"  then "month"
      else ""
    return "" if word == ""
    ext = if @state.interval == 1 then "" else "s"
    "#{word}#{ext}"
  occurLabel: ->
    return "" if @state.count == 1
    "s"
  render: ->
    D.div { style: {width: 375}},
      D.p  {}
      D.b  {}, "Repeats:"
      D.p  {}
      D.div {},
        D.div {style: {display: 'inline-block'}},
          D.select {ref: "ruleType", className: 'selPeriod', value: @state.rule_type, onChange: @updateRuleType},
            D.option {value: "Never"}                , "Never"
            D.option {value: "IceCube::DailyRule"}   , "Daily"
            D.option {value: "IceCube::WeeklyRule"}  , "Weekly"
            D.option {value: "IceCube::MonthlyRule"} , "Monthly"
          if @state.rule_type != "Never"
            D.div {className: "text-left small", style: {display: 'inline-block', paddingLeft: 10}},
              "every "
              D.input {ref: "interval", type: 'text', value: @state.interval, onChange: @updateInterval, style: {width: '30px', 'paddingLeft': '3px;' }}
              " #{@intervalLabel()}"
      if @state.rule_type != "Never"
        D.div {},
          D.p {}
          D.p {}
          D.b {}, "Ends: "
          D.br {}
          D.div {className: "radio"},
            D.label {},
              D.input {type:"radio", name:"radios", id:"options1", value:"never", onChange: @setNever, checked: @endsNever() }
              " Never"
            D.div {className: "radio"},
              D.label {},
                D.input {type:"radio", name:"radios", id:"options2", value:"after", onChange: @setAfter, checked: @endsAfter() }
                " After "
                if @endsAfter()
                  D.span {},
                    D.input {ref: 'count', type: "text", value: @state.count, onChange: @updateCount,  style: {marginLeft: '5px', width: '30px'}}
                      " occurrence#{@occurLabel()}"
            D.div {className: "radio"},
              D.label {},
                D.input {type:"radio", name:"radios", id:"options3", value:"on"   , onChange: @setOn, checked: @endsOn()    }
                " On "
                if @endsOn()
                  D.span {},
                  D.input {ref: 'until', type: "text", onChange: @updateUntil, value: @state.until, style: {marginLeft: '5px', width: '100px'}, placeholder: "YYYY-MM-DD"}

# ----- factory generation -----

_.each(_.keys(RC), (key)-> RF[key] = React.createFactory(RC[key]))

# ----- fini ------

module.exports = RC
window.Picker  = {}
window.Picker.Recur = RC.RecurPicker
window.Picker.Time  = RC.TimePicker