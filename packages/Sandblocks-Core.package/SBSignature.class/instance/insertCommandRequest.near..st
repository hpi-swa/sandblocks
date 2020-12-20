as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	| part index insertArg insertPart |
	self isBinary ifTrue: [^ nil].
	self isUnary ifTrue: [
		^ (SBInsertCommand newFor: self containingSandblock containingArtefact)
			container: self;
			index: self submorphCount + 1;
			morph: SBUnknown new;
			shouldMergeWithNext: true;
			yourself].
	
	index := aBlock owner = self
		ifTrue: [
			anAfterBoolean ifTrue: [aBlock submorphIndex + 1] ifFalse: [aBlock submorphIndex]]
		ifFalse: [1].
	part := SBMessagePart new contents: ':'.
	
	insertPart := (SBInsertCommand newFor: self containingSandblock containingArtefact)
		container: self;
		index: index;
		morph: part;
		shouldMergeWithNext: true;
		yourself.
	insertArg := (SBInsertCommand newFor: self containingSandblock containingArtefact)
		container: self;
		index: index;
		morph: SBUnknown new;
		yourself.
	^ SBCombinedCommand newWith: (index odd ifTrue: [{insertArg. insertPart}] ifFalse: [{insertPart. insertArg}])