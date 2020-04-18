as yet unclassified
outOfWorld: aWorld

	super outOfWorld: aWorld.
	
	self removeSuggestionMenu.
	self triggerEvent: #outOfWorld