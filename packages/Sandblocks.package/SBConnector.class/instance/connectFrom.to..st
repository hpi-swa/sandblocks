as yet unclassified
connectFrom: aSource to: aDestination

	self connect: aSource node signal: #positionChanged: toSelector: #updateConnection.
	self connect: aDestination node signal: #positionChanged: toSelector: #updateConnection.
	
	source := aSource.
	destination := aDestination.
	
	self updateConnection