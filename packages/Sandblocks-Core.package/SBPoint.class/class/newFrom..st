as yet unclassified
newFrom: aBlock

	^ self new
		x: aBlock receiver
		y: aBlock arguments first;
		type: (aBlock selector = ',' ifTrue: [ECSVector2] ifFalse: [Point])