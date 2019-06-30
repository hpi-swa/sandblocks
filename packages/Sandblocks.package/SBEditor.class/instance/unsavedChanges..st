as yet unclassified
unsavedChanges: aBoolean

	unsavedChanges ~= aBoolean ifTrue: [
		unsavedChanges := aBoolean.
		self changed]