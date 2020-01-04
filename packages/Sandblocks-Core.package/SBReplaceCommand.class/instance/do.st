as yet unclassified
do

	targetOldOwner := target owner.
	targetOldIndex := targetOldOwner submorphIndexOf: target.
	
	replacerOldOwner := replacer owner.
	replacerOldOwner ifNotNil: [
		replacerOldIndex := replacerOldOwner submorphIndexOf: replacer].
	
	target owner removeMorph: target.
	replacerOldOwner ifNotNil: [:o | o removeMorph: replacer].
	targetOldOwner addMorph: replacer asElementNumber: targetOldIndex.
	
	^ replacer