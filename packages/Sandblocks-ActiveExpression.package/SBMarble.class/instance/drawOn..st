drawing
drawOn: aCanvas

	self isSync
		ifTrue: [aCanvas fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle]
		ifFalse: [aCanvas fillOval: self bounds fillStyle: self fillStyle borderWidth: self borderWidth borderColor: self borderColor]