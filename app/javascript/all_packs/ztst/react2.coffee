recur = require "../../ztst/react2_recur"
child = require "../../ztst/react2_childex"
mount = require "../../ztst/react2_mount"

$(document).ready ->
  React.render recur.hello(), $('#recurTgt')[0]
  React.render recur.factory.App( txt: "this is text" ), $('#recurTgt2')[0]
  React.render child.factory.App(), $('#childEx')[0]
  React.render mount.factory.App( val: "wazzup"), $('#mount1')[0]
