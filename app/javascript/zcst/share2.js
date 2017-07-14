// see https://github.com/muaz-khan/WebRTC-Experiment/tree/master/screen-sharing

const myCounter = {"msg": "this is share2.js"};

module.exports = myCounter;

// screen.userid = 'username';

var screen = new Screen('screen-unique-id'); // argument is optional

// on getting local or remote streams
screen.onaddstream = function(e) {
  document.body.appendChild(e.video);
};

screen.openSignalingChannel = function(callback) {
  return io.connect().on('message', callback);
};

// check pre-shared screens
// it is useful to auto-view
// or search pre-shared screens
screen.check();

document.getElementById('share-screen').onclick = function() {
  console.log("CLICKED - LAUNCHING")
  screen.share();
};

