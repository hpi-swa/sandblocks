as yet unclassified
focusFrom: aMorph

	(aMorph notNil and: [aMorph ~= self] and: [aMorph ~= parentOption]) ifTrue: [aMorph active: false].
	self active: true.
	^ self