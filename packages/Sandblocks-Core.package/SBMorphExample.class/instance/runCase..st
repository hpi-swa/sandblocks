as yet unclassified
runCase: aCase

	| morph |
	self sendStartNotification.
	
	self clearErrors.
	morph := [self setUpMorph evaluate] on: Error do: [:error | ^ self reportError: error].
	view
		removeAllMorphs;
		addMorphBack: (morph center: view center).
	aCase evaluateFor: morph in: view