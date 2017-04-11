D = React.DOM
F = {}
E = {}

nations = ['britain', 'ireland', 'norway', 'sweden', 'denmark', 'germany',
  'holland', 'belgium', 'france', 'spain', 'portugal', 'italy', 'switzerland']

Typeahead = React.createClass
  getInitialState : -> {input: ""}
  handleChange    : -> @setState input: @refs.field.getDOMNode().value
  handleClick     : (nation)-> @setState input: nation
  matches         : (input)->
    regex = new RegExp(input, "i")
    _.filter nations, (nation)-> nation.match(regex) && nation != input
  render: ->
    D.div {},
      D.input {ref:'field', onChange: @handleChange, value: @state.input}
      D.br {}
      _.map @matches(@state.input), (nation)=>
        F.Button {key: nation, handleClick: @handleClick, name: nation}

Button = React.createClass
  onClick: -> @props.handleClick(@props.name)
  render:  ->
    classes = "btn btn-xs btn-default"
    D.button {className: classes, onClick: @onClick}, @props.name

F.Button = React.createFactory(Button)

myHello = ->
  D.div {},
    "hello von coffee"
    D.br {}
    D.b  {}, "Hello World from Coffee! (react111)"
    D.br {}
    D.h3 {}, "This is an h3!!"

module.exports = {hello: myHello, typeAhead: Typeahead}
