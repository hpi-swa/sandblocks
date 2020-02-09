selection
internalSelect: aBlock

	aBlock ~= selection ifTrue: [ | previousSelection |
		previousSelection := selection.
		selection := aBlock.
		selection ifNotNil: [
			selection
				 attachDecorator: SBSelectionDecorator new;
				 wasSelected;
				 ensureVisible].
		
		previousSelection ifNotNil: [
			previousSelection
				 detachDecorators: SBSelectionDecorator;
				 wasDeselected].
		
		self triggerEvent: #selectionChanged with: selection.
		self updateSelectionLabel]