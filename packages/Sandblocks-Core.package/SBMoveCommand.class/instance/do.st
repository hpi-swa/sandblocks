as yet unclassified
do

	oldOwner := morph owner.
	oldIndex := oldOwner submorphIndexOf: morph.
	container addMorph: morph asElementNumber: index.
	^ morph