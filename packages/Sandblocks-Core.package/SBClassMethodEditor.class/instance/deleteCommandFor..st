as yet unclassified
deleteCommandFor: aBlock

	aBlock childIndex < 2 ifTrue: [^ nil].
	self sandblockEditor do: (SBCombinedCommand newWith: {
		((SBDeleteMethodCategoryCommand newFor: self)
			category: aBlock category;
			class: self firstSubmorph relatedClass).
		((SBDeleteCommand newFor: self) target: aBlock)
	})