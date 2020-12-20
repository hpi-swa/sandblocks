initialize-release
markChangesAfterCommand: aCommand

	aCommand wasEdit ifTrue: [
		aCommand affectedArtefacts do: [:artefact | | saved |
			saved := false.
			compileTime = #compileOnChange ifTrue: [
				saved := self save: artefact tryFixing: false quick: false].
			artefact hasUnsavedChanges: saved not.
			artefact triggerEvent: #changed.
			self allBlocksDo: [:block | block artefactChanged: artefact]]]