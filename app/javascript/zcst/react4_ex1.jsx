// react4_ex1.jsx

var React    = require("react");
var ReactDOM = require("react-dom");

class Ex1 extends React.Component {
  render() {return(<h3>Hello EX1 {this.props.name}</h3>);}
}

node = $('#ex1')[0]

ReactDOM.render(<Ex1 name="John" />, node);

