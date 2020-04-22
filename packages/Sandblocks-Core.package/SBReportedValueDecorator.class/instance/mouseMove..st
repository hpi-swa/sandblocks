as yet unclassified
mouseMove: anEvent

	((SBWatch report: (self morph morphsAt: anEvent position) for: 702406834) allSatisfy: [:m | m = self morph or: [m isSandblock not]]) ifTrue: [self showLabel] ifFalse: [self hideLabel]