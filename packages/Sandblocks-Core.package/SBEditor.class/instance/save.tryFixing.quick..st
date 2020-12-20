artefacts
save: anArtefact tryFixing: aFixBoolean quick: aQuickBoolean

	^ (anArtefact saveTryFixing: aFixBoolean quick: aQuickBoolean)
		ifTrue: [
			anArtefact hasUnsavedChanges: false.
			self allBlocksDo: [:block | block artefactSaved: self selectedArtefact].
			true]
		ifFalse: [false]