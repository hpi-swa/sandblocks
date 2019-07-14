as yet unclassified
contentsChanged

	text contents ifEmpty: [
		self stopEditing.
		self replaceWithUnknown]