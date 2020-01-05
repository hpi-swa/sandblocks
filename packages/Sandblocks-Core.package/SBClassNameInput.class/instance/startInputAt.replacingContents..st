as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	(UIManager default chooseClassOrTrait) ifNotNil: [:class |
		self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
			target: self;
			selector: #contents;
			value: class name)].
	
	^ nil