as yet unclassified
type: aClass

	type := aClass.
	self hasSubmorphs ifTrue: [self submorphs second contents: self messageSelector asString]