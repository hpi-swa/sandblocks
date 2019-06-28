as yet unclassified
drawOn: aCanvas

	self sandblockEditor selection = self
		ifTrue: [aCanvas frameAndFillRectangle: self bounds fillColor: self color borderWidth: 2 borderColor: Color white]
		ifFalse: [aCanvas fillRectangle: self bounds color: self color]