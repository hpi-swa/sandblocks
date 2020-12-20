as yet unclassified
newFor: anObject

	^ SBRepl new receiver: anObject; statements: {SBName contents: 'self'}