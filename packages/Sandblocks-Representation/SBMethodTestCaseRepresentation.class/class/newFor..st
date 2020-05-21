as yet unclassified
newFor: anObject

	| block |
	block := anObject asSandblock.
	^ SBTestCase new
		selector: block selector arguments: block arguments class: block methodClass;
		body: block body;
		yourself