event handling
handlesMouseDown: anEvent

	^ anEvent redButtonPressed or: [
		SBPreferences rightClickContextMenu and: [anEvent yellowButtonPressed]]