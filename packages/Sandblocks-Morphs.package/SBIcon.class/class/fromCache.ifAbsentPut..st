caching
fromCache: aNameSymbol ifAbsentPut: aBlock

	| cache |
	cache := SVGCache ifNil: [SVGCache := Dictionary new].
	
	^ self new
		iconName: aNameSymbol;
		svg: (cache at: aNameSymbol ifAbsentPut: [ | doc |
			doc := XMLDOMParser parseDocumentFrom: aBlock value readStream.
			SBTransparentSvgMorph new
				createFromSVGDocument: doc;
				color: Color transparent;
				setProperty: #svgSource toValue: doc;
				yourself])