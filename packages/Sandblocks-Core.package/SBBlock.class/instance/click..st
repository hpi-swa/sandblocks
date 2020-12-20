as yet unclassified
click: anEvent

	self sandblockEditor selectClick: self at: anEvent position.
	(anEvent yellowButtonPressed and: [SBPreferences rightClickContextMenu]) ifTrue: [self promptAction]