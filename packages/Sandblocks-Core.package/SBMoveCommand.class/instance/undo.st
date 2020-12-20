as yet unclassified
undo

	container removeMorph: morph.
	oldOwner addMorph: morph asElementNumber: oldIndex.
	^ morph