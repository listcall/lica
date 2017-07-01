Reflux.ActionMethods.listeners    = -> @emitter.listeners(@eventLabel)
Reflux.ActionMethods.numListeners = -> @listeners().length

RA = Reflux.createActions [
    "optionLoad"
    "optionSelect"
    "periodLoad"
    "periodSelect"
    "periodUpdate"
    "modalSave"
    "modalClose"
  ]

module.exports = RA
