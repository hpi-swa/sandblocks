drawing
color

	^ self colorPolicy ifNotNil: #colorForEditor ifNil: [Color white]