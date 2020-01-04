actions
markChangesAfterCommand: aCommand

	aCommand wasEdit ifTrue: [
		aCommand affectedArtefacts do: [:artefact |
			artefact hasUnsavedChanges: true.
			self allBlocksDo: [:block | block artefactChanged: artefact]]].
	
	compileTime = #compileOnChange ifTrue: [self saveTryFixing: false]