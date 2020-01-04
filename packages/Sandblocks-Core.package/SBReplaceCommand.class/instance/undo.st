as yet unclassified
undo

	replacer owner removeMorph: replacer.
	targetOldOwner addMorph: target asElementNumber: targetOldIndex.
	replacerOldOwner ifNotNil: [
		replacerOldOwner addMorph: replacer asElementNumber: replacerOldIndex].
	
	^ replacer owner ifNotNil: [replacer] ifNil: [target]