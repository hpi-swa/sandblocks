as yet unclassified
layoutInset

	^ self isInCascade
		ifTrue: [(SBEdgeInsets left: 20 withScalingFactor right: 0 top: 0 bottom: 0) + super layoutInset]
		ifFalse: [super layoutInset]