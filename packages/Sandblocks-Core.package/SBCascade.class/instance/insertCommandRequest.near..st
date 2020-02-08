as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	^ (SBInsertCommand newFor: self containingArtefact)
		container: self;
		index: (self submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		shouldMergeWithNext: true;
		morph: (SBMessageSend new receiver: nil selector: #'' arguments: #())