event handling
stepTime

	^ self preventOcclusion ifTrue: [1] ifFalse: [-1]