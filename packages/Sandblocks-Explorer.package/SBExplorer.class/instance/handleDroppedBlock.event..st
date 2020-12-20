as yet unclassified
handleDroppedBlock: aBlock event: anEvent

	| newObject |
	newObject := aBlock object representationThat: #isObject.
	self on: newObject.
	field ifNotNil: [field setValueFor: field inspector to: newObject].
	self select.
	self toggleCollapsed.
	^ true