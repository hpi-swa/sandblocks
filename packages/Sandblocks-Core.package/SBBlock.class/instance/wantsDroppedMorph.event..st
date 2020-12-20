as yet unclassified
wantsDroppedMorph: aMorph event: evt

	^ (aMorph respondsTo: #object) and: [
		SBToggledCode
			comment: 'strong hit on performance'
			active: 2
			do: {
				[
					aMorph object hasRepresentationThat: (self fixedNumberOfChildren
						ifTrue: [self acceptedRepresentation]
						ifFalse: [
							self dropLocationDo: [:position :morph :horizontal |
								self parentSandblock contextAcceptedRepresentationAt: morph childIndex]])].
				[true]
			}]