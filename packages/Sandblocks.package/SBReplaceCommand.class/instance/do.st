as yet unclassified
do

	targetOldOwner := target owner.
	targetOldIndex := targetOldOwner submorphIndexOf: target.
	
	replacerOldOwner := replacer owner.
	replacerOldIndex := replacerOldOwner submorphIndexOf: replacer.
	
	target owner removeMorph: target.
	replacer owner removeMorph: replacer.
	targetOldOwner addMorph: replacer asElementNumber: targetOldIndex