as yet unclassified
newFor: anObject

	^ SBName contents: ((anObject isString or: [anObject isText]) ifTrue: [anObject] ifFalse: [anObject contents])