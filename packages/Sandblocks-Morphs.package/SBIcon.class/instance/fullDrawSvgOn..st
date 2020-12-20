colors
fullDrawSvgOn: aCanvas

	| source |
	source := svg valueOfProperty: #svgSource ifAbsent: [^ super fullDrawSvgOn: aCanvas].
	aCanvas
		drawSvg: (source root veryDeepCopy
			attributeAt: 'width' put: self width asString;
			attributeAt: 'height' put: self height asString;
			withAllElementsDo: [:e | e attributeAt: 'fill' put: self color toSVGString];
			yourself)
		at: self position