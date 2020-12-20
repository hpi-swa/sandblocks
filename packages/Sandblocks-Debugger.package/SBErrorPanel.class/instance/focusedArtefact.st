as yet unclassified
focusedArtefact

	self activeErrorDo: [:error | ^ self sandblockEditor open: error currentStackFrame context method].
	^ nil