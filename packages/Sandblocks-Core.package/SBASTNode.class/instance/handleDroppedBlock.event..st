as yet unclassified
handleDroppedBlock: aBlock event: anEvent

	self fixedNumberOfChildren
		ifTrue: [ | replacer |
			replacer := aBlock object anyRepresentationThat: self acceptedRepresentation.
			self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: replacer).
			replacer postDuplicate]
		ifFalse: [ | replacer |
			self dropLocationDo: [:position :morph :horizontal |
				replacer := aBlock object anyRepresentationThat: (self parentSandblock contextAcceptedRepresentationAt: morph childIndex).
				self sandblockEditor do: ((self insertCommandRequest: false near: morph) shouldMergeWithNext: true).
				self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
					target: self sandblockEditor selection;
					replacer: replacer)]]