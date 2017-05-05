console.log("HELLO WORLD FROM REACT5");

React    = require("react");
ReactDOM = require("react-dom");

const App = () => <h1>Hello Stateless</h1>

ReactDOM.render(<h1>Hello, world A!</h1>, $('#ex1')[0]);
ReactDOM.render(<h1>Hello, world B!</h1>, document.getElementById('ex2'));
ReactDOM.render(<App/>, document.getElementById('ex3'));

