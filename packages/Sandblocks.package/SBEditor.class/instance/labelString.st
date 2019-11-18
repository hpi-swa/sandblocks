input
labelString

	^ "self method ifNotNil: [:m | m methodClass name, '>>', m selector] ifNil: ["'Sandblocks Editor'"]"