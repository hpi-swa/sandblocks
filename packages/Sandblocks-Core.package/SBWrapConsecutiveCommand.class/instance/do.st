as yet unclassified
do

	targetOldOwner := targets first owner.
	targetOldIndex := targetOldOwner submorphIndexOf: targets first.
	
	targets first replaceBy: outer.
	wrap value: outer value: targets.
	^ targets first