as yet unclassified
newFor: anObject

	| base |
	base := ((UIManager default request: 'What base?') ifNil: [^ anObject]) asNumber.
	
	^ anObject veryDeepCopy
		contents: (base = 10 ifTrue: [''] ifFalse: [base asString, 'r']), (anObject parsedContents printStringBase: base);
		yourself