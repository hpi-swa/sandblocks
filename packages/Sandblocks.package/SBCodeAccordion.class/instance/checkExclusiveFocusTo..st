as yet unclassified
checkExclusiveFocusTo: aMorph

	| lens |
	aMorph ifNotNil: [
		lens := aMorph containingMethod owner owner.
		lens owner = self ifTrue: [
			lens expand.
			self submorphsDo: [:morph | morph = lens ifFalse: [morph collapseCompletely]]]]