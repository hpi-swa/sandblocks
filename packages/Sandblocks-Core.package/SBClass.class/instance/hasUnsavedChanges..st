as yet unclassified
hasUnsavedChanges: aBoolean

	hasUnsavedChanges ~= aBoolean ifTrue: [
		hasUnsavedChanges := aBoolean.
		self changed]