as yet unclassified
resolveLocalBindings

	| bindings |
	bindings := Array streamContents: [:stream |
		self allBlocksDo: [:block |
			block isBinding ifTrue: [ | binding |
				binding := block resolveBinding.
				(binding notNil and: [binding isTemporaryVariable or: [binding isBlockBinding] or: [binding isMethodArgument]]) ifTrue: [
					stream nextPut: binding]]]].
	
	^ (KeyedSet keyBlock: #name) addAll: bindings