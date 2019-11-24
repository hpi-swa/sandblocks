initialize-release
resetState

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	selectionDownHistory := OrderedCollection new.
	unsavedChanges := false.
	selection := self methods ifNotEmpty: #first ifEmpty: [nil].
	colorPolicy := colorPolicy class new.
	self mode: #command