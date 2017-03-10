D = React.DOM
F = {}

reactOutput = ->
  D.div {},
      "hello von coffee"
      D.br {}
      D.b  {}, "Hello World from Coffee!"

Slider = React.createClass
  render: ->
    D.input {type:'range', min:"0", max:"255", onChange:@props.update, style: {display: 'inline', width: '50%'}}

F.Slider = React.createFactory(Slider)

SlideCom = React.createClass
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
    D.div {},
        "Hello from App component "
        D.br {}
        F.Slider {ref: "red" , update:@updateTxt }
        " #{@state.red}"
        D.br {}
        F.Slider {ref: "green" , update:@updateTxt }
        " #{@state.green}"
        D.br {}
        F.Slider {ref: "blue"  , update:@updateTxt }
        " #{@state.blue}"

module.exports = SlideCom