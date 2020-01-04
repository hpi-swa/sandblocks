as yet unclassified
selector

	^ String streamContents: [:stream |
		self submorphs
			withIndexDo: [:m :i | i odd ifTrue: [stream nextPutAll: m contents]]]