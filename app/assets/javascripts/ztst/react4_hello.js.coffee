# test: javascripts/ztst/react4_hello_spec

D = React.DOM

HelloWorld = React.createClass
  getInitialState: -> { numClicks: 0 }
  wasClicked: -> @state.numClicks > 0
  handleClick: (_ev)->
    @setState( {numClicks: @state.numClicks + 1} )
  render: ->
    D.div {},
      D.button {ref: 'btn', className: 'btn btn-success', onClick: @handleClick}, "HELLO"
      D.span {}, " Numclicks: #{@state.numClicks}"

module.exports = HelloWorld