as yet unclassified
dropLocationDo: aBlock

	| mousePosition closestDist closestMorph |
	mousePosition := self
		valueOfProperty: #dropLocation
		ifAbsent: [
			^ aBlock value: self center value: self childSandblocks first value: false].
	closestDist := 900000000.
	closestMorph := nil.
	self childSandblocksDo: [:block | | dist |
		dist := block topLeft squaredDistanceTo: mousePosition.
		dist < closestDist ifTrue: [
			closestDist := dist.
			closestMorph := block]].
	^ closestMorph ifNotNil: [ | delta |
		delta := (((closestMorph adjacentBlock: 1) ifNil: [closestMorph adjacentBlock: -1]) ifNotNil: [:next | next topLeft - closestMorph topLeft] ifNil: [1 @ 0]) abs.
		aBlock value: closestMorph topLeft - (0 @ 4) value: closestMorph value: delta x < delta y]