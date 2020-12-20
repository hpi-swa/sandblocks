as yet unclassified
newFor: anObject

	^ "(anObject isString or: [anObject isText]) ifTrue: [anObject] ifFalse: [anObject contents]"anObject string