as yet unclassified
deleteCommandFor: aBlock

	^ (self canDeleteChild: aBlock)
		ifTrue: [(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]
		ifFalse: [
			aBlock nullBlockClass ifNotNil: [:nullBlockClass |
				(SBReplaceCommand newFor: aBlock containingArtefact) target: aBlock; replacer: nullBlockClass new]]