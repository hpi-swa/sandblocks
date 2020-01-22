artefact protocol
saveTryFixing: aBoolean quick: aQuickBoolean

	self allBlocksDo: [:block |
		block valid ifFalse: [
			"block isBinding ifTrue: [self addLocalBindingFor: block]."
			
			aBoolean ifFalse: [^ false] ifTrue: [block tryFixIfFail: [^ false]]]].
	
	^ true