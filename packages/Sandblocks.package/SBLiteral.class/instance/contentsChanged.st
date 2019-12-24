as yet unclassified
contentsChanged

	(self castToUnknownWhenEmpty and: [text contents isEmpty]) ifTrue: [
		self stopEditing.
		self replaceWithUnknown]