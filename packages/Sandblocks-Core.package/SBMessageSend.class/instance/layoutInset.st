as yet unclassified
layoutInset

	^ self isInCascade
		ifTrue: [super layoutInset + (SBEdgeInsets left: 20 withScalingFactor right: 0 top: 0 bottom: 0)]
		ifFalse: [super layoutInset]