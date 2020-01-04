initialize-release
resetState

	self clearUndoStack.
	selectionDownHistory := OrderedCollection new.
	selection := self methods ifNotEmpty: #first ifEmpty: [nil].
	colorPolicy := colorPolicy class new.
	self mode: #command