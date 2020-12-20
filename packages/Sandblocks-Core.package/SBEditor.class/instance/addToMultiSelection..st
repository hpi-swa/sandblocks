actions
addToMultiSelection: aBlock

	multiSelection add: aBlock.
	multiSelection copy do: [:morph | (morph hasOwner: aBlock) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock allOwnersDo: [:morph | (multiSelection includes: morph) ifTrue: [self removeMultiSelected: morph]].
	
	aBlock attachDecorator: SBMultiSelectionDecorator new.
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel