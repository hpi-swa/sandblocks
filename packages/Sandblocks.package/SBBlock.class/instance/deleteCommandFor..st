as yet unclassified
deleteCommandFor: aBlock

	^ (self canDeleteChild: aBlock)
		ifTrue: [(SBDeleteCommand newFor: aBlock containingMethod) target: aBlock]
		ifFalse: [(SBReplaceCommand newFor: aBlock containingMethod) target: aBlock; replacer: SBUnknown new]