as yet unclassified
inputs

	^ self selector isUnary
		ifTrue: [#('self')]
		ifFalse: [#('self'), self selector keywords]