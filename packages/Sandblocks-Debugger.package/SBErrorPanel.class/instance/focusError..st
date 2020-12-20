as yet unclassified
focusError: anError

	anError focus.
	commandBar ifNil: [self sandblockEditor addMorph: (commandBar := self buildDebugCommandBar) asElementNumber: 4]