as yet unclassified
runCase: aCase

	| morph |
	self sendStartNotification.
	
	self clearErrors.
	view removeAllMorphs.
	
	[
		morph := self setUpMorph evaluate.
		morph ifNotNil: [
			view addMorphBack: (morph center: view center).
			aCase evaluateFor: morph in: view]
	] value"on: Error do: [:error | ^ self reportError: error]."