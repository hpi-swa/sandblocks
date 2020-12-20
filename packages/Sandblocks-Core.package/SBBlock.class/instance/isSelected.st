testing
isSelected

	^ self sandblockEditor ifNil: [false] ifNotNil: [:editor | editor selection = self]