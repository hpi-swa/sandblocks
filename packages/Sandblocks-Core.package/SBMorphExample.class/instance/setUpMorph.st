accessing
setUpMorph

	" we can't just save a reference to it because editing ops may change the morph, but it's position will say the same "
	^ self firstSubmorph submorphs second