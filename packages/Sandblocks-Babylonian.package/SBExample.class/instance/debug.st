as yet unclassified
debug
	<action>

	| process |
	process := Process
		forBlock: [self evaluate]
		runUntil: [:context |
			context method == self containingArtefact compiledMethod].
	self sandblockEditor reportError: nil process: process.
	self sandblockEditor errors focusErrors