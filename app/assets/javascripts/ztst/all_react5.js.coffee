window.VT = {};
window.F  = {}

D = React.DOM

VT.RBS = ReactBootstrap
VT.My  = {}

VT.My.Button1 = React.createClass
  getInitialState: -> {numClicks: 0}
  handleClick: ->
    console.log "WAS CLICKED"
    @setState {numClicks: @state.numClicks + 1}
  render: ->
    D.div {},
      React.createElement(VT.RBS.Button, {bsStyle: 'success', onClick: @handleClick}, "CLICK ME")
      D.span {}, " Numclicks: #{@state.numClicks}"
F.Button1 = React.createFactory(VT.My.Button1)

VT.My.Button2 = React.createClass
  render: ->
    React.createElement(VT.RBS.Button, {bsStyle: 'danger'}, "DANGER")
F.Button2 = React.createFactory(VT.My.Button2)

VT.My.ButtonRadium = React.createClass
  mixins: [Radium.StyleResolverMixin, Radium.BrowserStateMixin]
  render: ->
    styles =
      cursor      : 'pointer'
      border      : 0
      padding     : 10
      outline     : 'none'
      fontSize    : 12
      fontWeight  : 'bold'
      fontColor   : '#fff'
      marginRight : 10
      borderRadius: 10
      states: [
        {hover: {background: 'black'}}
        {focus: {background: 'pink'}}
      ]
      modifiers: [
        {kind: {
          primary: {background: 'green'}
          warning: {background: 'red'}
        }}
      ]
    props = _.extend(@getBrowserStateEvents(), {style: @buildStyles(styles)})
    D.button props, "HELLO #{@props.kind}"
F.ButtonRadium = React.createFactory(VT.My.ButtonRadium)

VT.My.Button3 = React.createClass
  render: ->
    D.div {},
      F.ButtonRadium {}
      F.ButtonRadium {kind: 'primary'}
      F.ButtonRadium {kind: 'warning'}
F.Button3 = React.createFactory(VT.My.Button3)

$(document).ready ->
  React.render React.createElement(VT.RBS.Panel , {}, "ASDF"), $('#panel')[0]
  React.render F.Button1({}, "ASDF"), $('#button1')[0]
  React.render F.Button2({}), $('#button2')[0]
  React.render F.Button3({}), $('#button3')[0]

