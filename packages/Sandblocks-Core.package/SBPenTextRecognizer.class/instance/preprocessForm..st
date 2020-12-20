as yet unclassified
preprocessForm: aForm

	| scale newForm decal target |
	scale  := (self requiredFormExtent y / aForm width min: self requiredFormExtent x / aForm height).
	"^ aForm rotateBy: 90 magnify: scale smoothing: 4"
	newForm := aForm blankCopyOf: aForm boundingBox scaledBy: scale * 0.9.
	(WarpBlt toForm: newForm)
                sourceForm: aForm;
                colorMap: (aForm colormapIfNeededFor: newForm);
                cellSize: 8;
                combinationRule: 3;
                copyQuad: aForm boundingBox innerCorners toRect: newForm boundingBox.
	
	decal := (newForm rotateBy: -90) flipVertically.
	target := Form extent: self requiredFormExtent depth: 8.
	target getCanvas
		fillColor: Color white;
		translucentImage: decal at: ((target width / 2) - (decal width / 2)) floor @ 0"(target height - decal height)".
	
	^ target