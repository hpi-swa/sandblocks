as yet unclassified
replace: aBlock with: anotherBlock

	SBExample allInstancesDo: [:example |
		example isCurrent ifTrue: [^ anotherBlock value]].
	
	^ aBlock value