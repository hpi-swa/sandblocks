as yet unclassified
behavior: anObject

	behavior class ~= anObject class ifTrue: [
		behavior := anObject.
		anObject attached: self]