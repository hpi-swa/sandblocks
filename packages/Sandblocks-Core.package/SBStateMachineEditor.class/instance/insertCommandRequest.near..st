initialization
insertCommandRequest: anAfterBoolean near: aBlock

	^ (SBInsertCommand newFor: self containingArtefact)
		index: self submorphCount + 1;
		container: self;
		morph: (SBStateMachineState new name: 'unnamed'; position: self position + (30 @ 30));
		yourself