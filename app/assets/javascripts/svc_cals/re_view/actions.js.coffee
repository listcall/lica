Reflux.ActionMethods.listeners    = -> @emitter.listeners(@eventLabel)
Reflux.ActionMethods.numListeners = -> @listeners().length

RA = Reflux.createActions [
    "btnNew"
    "btnCreate"
    "btnUpdate"
    "btnDelete"
    "btnCancel"
    "btnCycle"
    "btnSignIn"
    "btnSignOut"
    "modTime"
    "modService"
    "modRepeat"
    "eventLoad"
    "cellArrowKey"
    "cellClick"
    "eventClick"
    "updateFilter"
  ]

module.exports = RA
