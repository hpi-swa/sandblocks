as yet unclassified
runCase: aCase

	| morph |
	self sendStartNotification.
	
	morph := self setUpMorph evaluate.
	view
		removeAllMorphs;
		addMorphBack: (morph center: view center).
	aCase evaluateFor: morph in: view