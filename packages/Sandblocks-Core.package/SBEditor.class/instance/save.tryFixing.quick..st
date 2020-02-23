actions
save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean

	^ (anArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			self allBlocksDo: [:block | block artefactSaved: self method].
			true]
		ifFalse: [false]