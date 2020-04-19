as yet unclassified
debug

	| process |
	process := Process
		forBlock: [self evaluate]
		runUntil: [:context | context method == self containingArtefact compiledMethod].
	
	self sandblockEditor reportError: process suspendedContext process: process