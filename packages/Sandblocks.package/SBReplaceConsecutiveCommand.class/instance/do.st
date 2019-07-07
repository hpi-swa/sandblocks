as yet unclassified
do

	targetOldOwner := targets first owner.
	targetOldIndex := targetOldOwner submorphIndexOf: targets first.
	
	replacerOldOwner := replacer owner.
	replacerOldOwner ifNotNil: [
		replacerOldIndex := replacerOldOwner submorphIndexOf: replacer].
	
	targets do: #delete.
	replacerOldOwner ifNotNil: [:o | o removeMorph: replacer].
	targetOldOwner addMorph: replacer asElementNumber: targetOldIndex.
	
	^ replacer