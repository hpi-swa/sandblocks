as yet unclassified
mouseMove: anEvent

	| closestMorph |
	(self center squaredDistanceTo: anEvent position) < (60 ** 2) ifTrue: [
		activeMorph ifNotNil: [activeMorph active: false].
		activeMorph := nil.
		^ self].
	
	closestMorph := self submorphs
		inject: self firstSubmorph
		into: [:closest :morph | 
			(closest center squaredDistanceTo: anEvent position) > (morph center squaredDistanceTo: anEvent position)
				ifTrue: [morph]
				ifFalse: [closest]].
	
	activeMorph := closestMorph focusFrom: activeMorph