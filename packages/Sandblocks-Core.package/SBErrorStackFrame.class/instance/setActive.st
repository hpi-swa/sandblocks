as yet unclassified
setActive

	self isSelected
		ifTrue: [self updateSelection]
		ifFalse: [self select]