as yet unclassified
matches: anObject

	| contents |
	(anObject respondsTo: #contents) ifFalse: [^ false].
	contents := [anObject contents] on: Error do: [^ false].
	^ anObject isText not and: [contents isString or: [anObject contents isText]]