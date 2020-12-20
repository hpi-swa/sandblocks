as yet unclassified
deleteCommandFor: aBlock

	self isUnary ifTrue: [
		^ (SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: self receiver].
	
	^ aBlock = self receiver ifTrue: [super deleteCommandFor: aBlock] ifFalse: [signature deleteCommandFor: aBlock]