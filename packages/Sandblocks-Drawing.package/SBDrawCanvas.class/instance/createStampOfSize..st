as yet unclassified
createStampOfSize: aNumber

	| form |
	SBExample self: [SBDrawCanvas basicNew] args: [{32}] label: 'small'.
	form := Form extent: aNumber asPoint depth: 32.
	form getCanvas
		fillRectangle: form boundingBox
		fillStyle: ((GradientFillStyle ramp: {(0.0 -> (Color white alpha: 0.9)). (0.8 -> (Color white alpha: 0))})
			 origin: aNumber asPoint // 2;
			 radial: true;
			 direction: aNumber asPoint // 2;
			 yourself).
	SBExampleWatch report: (form := form collectColors: [:col | Color black alpha: col red]) for: 893886548.
	^ form