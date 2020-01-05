selection
internalSelect: aBlock

	| previousSelection |
	previousSelection := selection.
	selection := aBlock.
	
	previousSelection ~= selection ifTrue: [
		selection ifNotNil: [
			selection
				attachDecorator: SBSelectionDecorator new;
				wasSelected;
				ensureVisible].
		
		previousSelection ifNotNil: [previousSelection detachDecorators: SBSelectionDecorator].
		
		self triggerEvent: #selectionChanged with: selection.
		self updateSelectionLabel]