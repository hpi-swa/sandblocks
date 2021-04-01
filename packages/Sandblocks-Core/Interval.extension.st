Extension { #name : #Interval }

{ #category : #'*Sandblocks-Core' }
Interval >> distanceTo: aNumber [

	(aNumber >= start and: [aNumber <= stop]) ifTrue: [^ 0].
	aNumber < start ifTrue: [^ start - aNumber].
	^ aNumber - stop
]
