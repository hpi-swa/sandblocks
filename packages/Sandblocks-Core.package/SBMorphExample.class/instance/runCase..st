as yet unclassified
runCase: aCase

	self sendStartNotification.
	view
		removeAllMorphs;
		addMorphBack: (self setUpMorph evaluate center: view center)