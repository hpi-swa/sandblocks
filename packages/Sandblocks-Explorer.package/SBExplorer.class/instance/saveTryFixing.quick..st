as yet unclassified
saveTryFixing: aFixBoolean quick: aQuickBoolean

	| newObject |
	self label isSandblock ifFalse: [^ false].
	newObject := self label evaluate.
	self on: newObject.
	field ifNotNil: [field setValueFor: field inspector to: newObject].
	self select.
	self toggleCollapsed.
	^ true