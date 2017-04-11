R = React.DOM
F = {}

BButton = React.createClass
  render: ->
    @props.className = "btn #{@props.className}"
    R.a @props, @props.children

F.BButton = React.createFactory(BButton)

BHeart = React.createClass
  render: ->
    R.i className: "fa fa-cog"

F.BHeart = React.createFactory(BHeart)

App = React.createClass
  render: ->
    R.div {},
      "HELLO APP "
      F.BHeart {}
      R.br {}
      F.BButton({className: "btn-primary"}, "REACT")
      F.BButton({className: "btn-success"}, "REACT")
      F.BButton({className: "btn-danger"},  "REACT")
      R.br {}
      F.BHeart null
      " bye app"

F.App = React.createFactory(App)

module.exports = {factory: F}
