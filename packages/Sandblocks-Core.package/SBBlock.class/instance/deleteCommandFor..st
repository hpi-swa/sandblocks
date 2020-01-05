as yet unclassified
deleteCommandFor: aBlock

	^ (self canDeleteChild: aBlock)
		ifTrue: [(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]
		ifFalse: [(SBReplaceCommand newFor: aBlock containingArtefact) target: aBlock; replacer: SBUnknown new]