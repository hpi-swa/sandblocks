geometry testing
defaultColor

	^ (self owner ifNotNil: [:editor | editor colorPolicy ifNotNil: #colorForEditor]) ifNil: [Color white]