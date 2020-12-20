as yet unclassified
mutateColor: aColor

	^ Color h: aColor hue + 30 s: aColor saturation v: (aColor brightness > 0.6 ifTrue: [aColor brightness - 0.3] ifFalse: [0.3 + aColor brightness])