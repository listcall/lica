R = React.DOM
F = {}

reactHello = ->
  R.div {},
    "hello von coffee"
    R.br {}
    R.b  {}, "Hello World from Coffee!"

Slider = React.createClass
  render: ->
    R.input {type:'range', min:"0", max:"255", onChange:@props.update, style: {display: 'inline', width: '50%'}}

F.Slider = React.createFactory(Slider)

App = React.createClass
  getInitialState: ->
    red  : 128
    green: 128
    blue : 128
  updateTxt: ->
    @setState
      red  : @refs.red.getDOMNode().value
      green: @refs.green.getDOMNode().value
      blue : @refs.blue.getDOMNode().value
  getDefaultProps: ->
    txt: "HIHI"
    cat: 99
  propTypes:
    txt: React.PropTypes.string
    cat: React.PropTypes.number
  render: ->
    R.div {},
      "Hello from App component "
      R.br {}
      F.Slider( ref: "red"   , update:@updateTxt )
      " #{@state.red}"
      R.br {}
      F.Slider( ref: "green" , update:@updateTxt )
      " #{@state.green}"
      R.br {}
      F.Slider( ref: "blue"  , update:@updateTxt )
      " #{@state.blue}"

F.App = React.createFactory(App)

module.exports = {hello: reactHello, factory: F}
