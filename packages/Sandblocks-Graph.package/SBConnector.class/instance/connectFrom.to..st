as yet unclassified
connectFrom: aSource to: aDestination

	self connect: aSource node signal: #positionChanged: toSelector: #updateConnection.
	self connect: aDestination node signal: #positionChanged: toSelector: #updateConnection.
	
	aSource socket notifyConnectTo: self.
	aDestination socket notifyConnectTo: self.
	
	source := aSource socket.
	destination := aDestination socket.
	
	self updateConnection