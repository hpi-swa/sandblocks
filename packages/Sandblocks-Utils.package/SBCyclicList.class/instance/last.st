as yet unclassified
last

	^ array at: (cursor = 1 ifTrue: [array size] ifFalse: [cursor - 1])