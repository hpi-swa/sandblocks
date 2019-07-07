initialize-release
resetState

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	selectionDownHistory := OrderedCollection new.
	unsavedChanges := false.
	selection := self method.
	self mode: #command