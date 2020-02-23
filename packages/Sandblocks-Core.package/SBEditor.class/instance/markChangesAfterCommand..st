initialize-release
markChangesAfterCommand: aCommand

	aCommand wasEdit ifTrue: [
		aCommand affectedArtefacts do: [:artefact | | saved |
			saved := false.
			compileTime = #compileOnChange ifTrue: [saved := self save: artefact tryFixing: false quick: false].
			
			artefact hasUnsavedChanges: saved not.
			self allBlocksDo: [:block | block artefactChanged: artefact]]]