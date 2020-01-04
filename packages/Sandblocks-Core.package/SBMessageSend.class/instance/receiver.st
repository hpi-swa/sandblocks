as yet unclassified
receiver

	(self owner notNil and: [self isInCascade]) ifTrue: [self owner receiver].
	self submorphCount = 2 ifTrue: [^ self firstSubmorph].
	^ nil