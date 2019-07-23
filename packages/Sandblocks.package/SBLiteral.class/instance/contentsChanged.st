as yet unclassified
contentsChanged

	(castToUnknownWhenEmpty and: [text contents isEmpty]) ifTrue: [
		self stopEditing.
		self replaceWithUnknown]