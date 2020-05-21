as yet unclassified
intoWorld: aWorld

	super intoWorld: aWorld.

	" since our newFrom: needs to be side-effect free, we queue up adding the morph until we're actually being used "	
	addMorphLater ifNotNil: [
		self addMorphBack: addMorphLater.
		addMorphLater := nil]