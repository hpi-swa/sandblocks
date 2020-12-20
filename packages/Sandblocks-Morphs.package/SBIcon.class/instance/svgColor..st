colors
svgColor: aColor

	svgColor := aColor.
	cachedForm := nil.
	self svg allMorphsDo: [:morph | morph style at: 'fill' put: aColor].
	self svg changed