as yet unclassified
undo

	replacer owner removeMorph: replacer.
	targets withIndexDo: [:target :index |
		targetOldOwner addMorph: target asElementNumber: targetOldIndex + index - 1].
	
	replacerOldOwner ifNotNil: [
		replacerOldOwner addMorph: replacer asElementNumber: replacerOldIndex].
	
	^ replacer owner ifNotNil: [replacer] ifNil: [targets first]