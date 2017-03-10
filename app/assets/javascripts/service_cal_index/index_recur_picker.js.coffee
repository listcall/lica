r = React.DOM

RecurPicker = React.createClass

  # ----- handle -----

  componentDidMount: -> window.recurPicker = this

  # ----- state management -----

  getDefaultProps: -> rule : {}

  getInitialState: ->
    rule_type : @props.rule.rule_type || "Never"
    interval  : @props.rule.interval  || 1
    ends      : "Never"
    count     : @props.rule.count     || 1
    until     : @props.rule.until     || "2014-09-01"

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

  toHash: ->
    obj = {
      rule_type : @state.rule_type
      interval  : @state.interval
    }
    switch @state.ends
      when "After" then obj.count = @state.count
      when "On"    then obj.until = @state.until
    obj

  # ----- updaters -----

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

  # ----- setter utilities -----

  setNever   : -> @setState ends: "Never"
  setAfter   : -> @setState ends: "After"
  setOn      : -> @setState ends: "On"

  # ----- predicate utilities -----

  endsNever  : -> @state.ends == "Never"
  endsAfter  : -> @state.ends == "After"
  endsOn     : -> @state.ends == "On"

  # ----- render helpers -----

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

  # ----- render function -----

  render: ->
    r.div {},
      r.p  {}
      r.b  {}, "Repeats:"
      r.p  {}
      r.div {className: "row"},
        r.div {className: "col-xs-3"},
          r.select {ref: "ruleType", className: 'form-control input-sm', value: @state.rule_type, onChange: @updateRuleType},
            r.option {value: "Never"}                , "Never"
            r.option {value: "IceCube::DailyRule"}   , "Daily"
            r.option {value: "IceCube::WeeklyRule"}  , "Weekly"
            r.option {value: "IceCube::MonthlyRule"} , "Monthly"
        if @state.rule_type != "Never"
          r.div {className: "col-xs-6 text-left small", style: {'margin-top': '3px'}},
            "every "
            r.input {ref: "interval", type: 'text', value: @state.interval, onChange: @updateInterval, style: {width: '30px', 'padding-left': '3px;' }}
            " #{@intervalLabel()}"
      if @state.rule_type != "Never"
        r.div {},
          r.p {}
          r.p {}
          r.b {}, "Ends: "
          r.br {}
          r.div {className: "radio"},
            r.label {},
              r.input {type:"radio", name:"radios", id:"options1", value:"never", onClick: @setNever, checked: @endsNever() }
              " Never"
          r.div {className: "radio"},
            r.label {},
              r.input {type:"radio", name:"radios", id:"options2", value:"after", onClick: @setAfter, checked: @endsAfter() }
              " After "
            if @endsAfter()
              r.span {},
                r.input {ref: 'count', type: "text", value: @state.count, onChange: @updateCount,  style: {width: '30px', 'padding-left': '3px'}}
                " occurrence#{@occurLabel()}"
          r.div {className: "radio"},
            r.label {},
              r.input {type:"radio", name:"radios", id:"options3", value:"on"   , onClick: @setOn, checked: @endsOn()    }
              " On "
            if @endsOn()
              r.span {},
                r.input {ref: 'until', type: "text", onChange: @updateUntil, value: @state.until, style: {width: '100px'}, placeholder: "YYYY-MM-DD"}

RecurSet = React.createClass
  render: ->
    rule = {rule_type: "IceCube::DailyRule", interval: 5, count: 8}
    r.div {},
      r.div {}, RecurPicker({rule: rule})

$(document).ready ->
  React.renderComponent RecurSet(), $('#recur')[0]