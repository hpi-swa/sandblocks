as yet unclassified
focus: aBlock

	aBlock ifNotNil: [
		aBlock marked: true.
		self applyMode: #focus]