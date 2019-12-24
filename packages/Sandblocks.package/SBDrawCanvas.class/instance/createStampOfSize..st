as yet unclassified
createStampOfSize: aNumber 
	| form |
	SBExample
		self: [SBDrawCanvas new]
		args: [{32}]
		label: 'small'.
	form := Form extent: aNumber asPoint depth: 32.
	form getCanvas fillRectangle: form boundingBox fillStyle: ((GradientFillStyle ramp: {0.0 -> Color white. 0.5
				-> (Color white alpha: 0)}) origin: aNumber asPoint // 2;
			 radial: true;
			 direction: aNumber asPoint // 2;
			 yourself).
	^ form