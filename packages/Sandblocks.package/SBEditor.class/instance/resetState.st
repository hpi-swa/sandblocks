initialize-release
resetState

	undoStack := OrderedCollection new.
	redoStack  := OrderedCollection new.
	selectionDownHistory := OrderedCollection new.
	unsavedChanges := false.
	selection := self method.
	colorPolicy := SBDefaultColorPolicy new.
	self mode: #command