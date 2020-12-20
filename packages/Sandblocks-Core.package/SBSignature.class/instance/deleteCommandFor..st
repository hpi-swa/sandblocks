as yet unclassified
deleteCommandFor: aBlock

	| index |
	(self isUnary or: [self isBinary]) ifTrue: [
		^ (SBReplaceCommand newFor: aBlock containingArtefact)
			target: aBlock;
			replacer: SBUnknown new].
	
	(self isKeyword and: self submorphCount = 2) ifTrue: [
		^ aBlock submorphIndex = 1 ifTrue: [nil] ifFalse: [
			(SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock]].
	
	index := ((((self submorphs indexOf: aBlock) - 1) / 2) floor * 2) + 1.
	^ SBCombinedCommand newWith: {
		((SBDeleteCommand newFor: aBlock containingArtefact) target: (self submorphs at: index)).
		((SBDeleteCommand newFor: aBlock containingArtefact) target: (self submorphs at: index + 1))
	}