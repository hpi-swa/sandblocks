as yet unclassified
newFor: aMethodOrClass

	| editor |
	editor := self new.
	editor open: aMethodOrClass.
	editor clearUndoStack.
	
	^ editor