selection
internalSelect: aBlock

	aBlock ~= selection ifTrue: [ | previousSelection |
		previousSelection := selection.
		selection := aBlock.
		selection ifNotNil: [
			self updateVerticalSelectionPosition.
			selection
				attachDecorator: SBSelectionDecorator new;
				wasSelected;
				ensureVisible].
		
		previousSelection ifNotNil: [
			previousSelection
				detachDecorators: SBSelectionDecorator;
				wasDeselected].
		
		self mode = #continuousSelection ifTrue: [self addToMultiSelection: selection].
		
		self triggerEvent: #selectionChanged with: selection.
		self updateSelectionLabel]