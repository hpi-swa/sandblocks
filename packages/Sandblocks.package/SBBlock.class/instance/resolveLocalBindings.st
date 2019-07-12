as yet unclassified
resolveLocalBindings

	| bindings |
	bindings := Array streamContents: [:stream |
		self allBlocksDo: [:block |
			block isBinding ifTrue: [ | binding |
				binding := block resolveBinding.
				
				(binding notNil and: [binding isDeclaration] and: [binding isMethodLocal] and: [(binding hasOwner: self) not]) ifTrue: [
					stream nextPut: binding]]]].
	
	^ (KeyedSet keyBlock: #name) addAll: bindings