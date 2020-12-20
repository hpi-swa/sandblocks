actions
removeMultiSelected: aMorph

	aMorph detachDecorators: SBMultiSelectionDecorator.
	multiSelection remove: aMorph.
	multiSelection ifEmpty: [self mode: #command]