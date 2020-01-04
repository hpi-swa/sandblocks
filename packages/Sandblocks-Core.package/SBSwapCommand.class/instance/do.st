as yet unclassified
do

	| aIndex aOwner bIndex bOwner |
	aOwner := a owner.
	aIndex := aOwner submorphIndexOf: a.
	
	bOwner := b owner.
	bIndex := bOwner submorphIndexOf: b.
	
	"aOwner removeMorph: a.
	bOwner removeMorph: b."
	aOwner addMorph: b asElementNumber: aIndex.
	bOwner addMorph: a asElementNumber: bIndex.
	^ a