as yet unclassified
focusedArtefact

	self activeErrorDo: [:error | ^ self sandblockEditor openCompiledMethod: error currentStackFrame context method].
	^ nil