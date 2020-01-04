selection
internalSelect: aBlock

	| previousSelection |
	previousSelection := selection.
	selection := aBlock.
	
	selection ifNotNil: [
		selection
			changed;
			wasSelected;
			ensureVisible].
	
	previousSelection ifNotNil: #changed.
	
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel