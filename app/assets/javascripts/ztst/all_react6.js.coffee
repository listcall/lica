D = React.DOM
F = {}
E = {}

BsPopover = React.createClass
  componentDidMount: ->
    $el = $(@getDOMNode())
    $el.popover
      react    : true
      title    : @props.title
      content  : @props.content
      trigger  : ''
      placement: @props.placement || undefined
    $el.popover('show') if @props.visible
  componentDidUpdate: (prevProps, prevState)->
    $el = $(@getDOMNode())
    if prevProps.visible != @props.visible
      stringVar = if @props.visible then 'show' else 'hide'
      $el.popover(stringVar)
  componentWillUnmount: ->
    # Clean up before destroying: this isn't strictly
    # necessary, but it prevents memory leaks
    $el     = $(@getDOMNode())
    popover = $el.data('bs.popover')
    $tip    = popover.tip()
    React.unmountComponentAtNode $tip.find('.popover-title')[0]
    React.unmountComponentAtNode $tip.find('.popover-content')[0]
    $(@getDOMNode()).popover('destroy')
  render: -> @props.children

Time = React.createClass
  render              : -> D.span {}, String(new Date)
  componentDidMount   : -> @interval = setInterval(@forceUpdate.bind(this), 100)
  componentWillUnmount: -> clearInterval @interval

F.Time = React.createFactory(Time)

PopoverDemo = React.createClass
  getInitialState: -> { visible: false }
  handleClick    : (ev)->
    ev.preventDefault()
    @setState {visible: !@state.visible}
  render: ->
    opts =
      title    : D.b   {}, "HELLO WORLD!"
      content  : D.div {}, ["Time is ", F.Time()]
      placement: "bottom"
      visible  : @state.visible
    BsPopover opts,
      D.a {className: "btn btn-lg btn-danger", onClick: @handleClick},
        "Click to toggle popover"

React.render React.createElement('div', {}, "test1"), $('#reactHere')[0]
# TODO: FIX THIS!!
#React.render React.createElement(PopoverDemo), $('#reactHere')[0]
zDiv = React.createElement('div', {}, "TEST CONTENT")
React.render zDiv, $('#reactThere')[0]

