initialize-release
resetState

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	selectionDownHistory := OrderedCollection new.
	unsavedChanges := false.
	selection := self method.
	colorPolicy := colorPolicy class new.
	self mode: #command