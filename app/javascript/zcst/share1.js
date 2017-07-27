// This is an experiment with Temasys Skylink
// 07 May 2016 - could not get it working

const myCounter = {"msg": "this is share1.js"};

module.exports = myCounter;

var skylink = new Skylink();

skylink.on('peerJoined', function(peerId, peerInfo, isSelf) {
    if(isSelf) return; // We already have a video element for our video and don't need to create a new one.
      var vid = document.createElement('video');
        vid.autoplay = true;
          vid.muted = true; // Added to avoid feedback when testing locally
            vid.id = peerId;
              document.body.appendChild(vid);
});

skylink.on('peerLeft', function(peerId, peerInfo, isSelf) {
    var vid = document.getElementById(peerId);
      document.body.removeChild(vid);
});

skylink.on('mediaAccessSuccess', function(stream) {
    var vid = document.getElementById('myvideo');
      attachMediaStream(vid, stream);
});

var date = new Date();

skylink.init({
  apiKey: '700e85c7-a0be-46f6-902b-958039f5b958',
  credentials: {
    startDateTime: date.toISOString(), // Date ISO string format
    duration: 1, // In hours
    credentials: "fyi26flhxk2tv", // The generated credentials based off step 2
  },
  defaultRoom: 'Pick a room name'
  }, function() {
    skylink.joinRoom({
          audio: true,
              video: true
                  });
});

