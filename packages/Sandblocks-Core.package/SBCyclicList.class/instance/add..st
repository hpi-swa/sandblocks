as yet unclassified
add: aNumber

	array at: cursor put: aNumber.
	cursor := cursor + 1.
	cursor > array size ifTrue: [cursor := 1]