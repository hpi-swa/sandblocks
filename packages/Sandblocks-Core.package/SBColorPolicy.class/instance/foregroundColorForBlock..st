as yet unclassified
foregroundColorForBlock: aBlock

	| color |
	color := aBlock drawnColor.
	(color alpha = 0 and: [aBlock parentSandblock notNil]) ifTrue: [color := aBlock parentSandblock drawnColor].
	^ self foregroundColorForColor: color