initialize-release
resetState

	self clearUndoStack.
	
	"self inputMapping resetState."
	selectionDownHistory := OrderedCollection new.
	selection := nil.
	self mode: #command.
	
	colorPolicy := colorPolicy class new