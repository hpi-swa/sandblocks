caching
fromCache: aNameSymbol ifAbsentPut: aBlock

	| cache |
	cache := SVGCache ifNil: [SVGCache := Dictionary new].
	
	^ self new
		iconName: aNameSymbol;
		svg: (cache at: aNameSymbol ifAbsentPut: [
			SBTransparentSvgMorph new
				createFromSVGDocument: (XMLDOMParser parseDocumentFrom: aBlock value readStream);
				color: Color transparent;
				yourself])