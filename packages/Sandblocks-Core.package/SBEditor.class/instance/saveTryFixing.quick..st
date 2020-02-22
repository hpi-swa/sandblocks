actions
saveTryFixing: aFixBoolean quick: aQuickBoolean

	^ (self selectedArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			self allBlocksDo: [:block | block artefactSaved: self method].
			true]
		ifFalse: [false]