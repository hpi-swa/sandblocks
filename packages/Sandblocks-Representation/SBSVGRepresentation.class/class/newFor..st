as yet unclassified
newFor: anObject

	^ SBTransparentSvgMorph new
		createFromSVGDocument: anObject;
		color: Color transparent;
		yourself