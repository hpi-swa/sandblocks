as yet unclassified
mouseMove: anEvent

	((self morph morphsAt: anEvent position) allSatisfy: [:m | m = self morph or: [m isSandblock not]]) ifTrue: [self showLabel] ifFalse: [self hideLabel]