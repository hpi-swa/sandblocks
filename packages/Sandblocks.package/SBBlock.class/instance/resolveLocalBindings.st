as yet unclassified
resolveLocalBindings

	^ Array streamContents: [:stream |
		self allBlocksDo: [:block |
			block isBinding ifTrue: [ | binding |
				binding := block resolveBinding.
				(binding notNil and: [binding isTemporaryVariable or: [binding isBlockBinding]]) ifTrue: [
					stream nextPut: binding]]]]