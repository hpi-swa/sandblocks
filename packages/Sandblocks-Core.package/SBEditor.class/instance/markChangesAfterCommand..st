initialize-release
markChangesAfterCommand: aCommand

	| saved |
	saved := false.
	compileTime = #compileOnChange ifTrue: [saved := self saveTryFixing: false quick: false].
	
	aCommand wasEdit ifTrue: [
		aCommand affectedArtefacts do: [:artefact |
			artefact hasUnsavedChanges: saved not.
			self allBlocksDo: [:block | block artefactChanged: artefact]]]