initialize-release
resetState

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	selectionDownHistory := OrderedCollection new.
	unsavedChanges := false.
	selection := self methods ifNotEmpty: #first.
	colorPolicy := colorPolicy class new.
	self mode: #command