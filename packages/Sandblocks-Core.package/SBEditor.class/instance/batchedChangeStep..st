artefacts
batchedChangeStep: aBlock

	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "
	compileTime = #compileOnChange ifTrue: [ | artefact |
		self save: aBlock containingArtefact tryFixing: false quick: true.
		artefact := self selectedArtefact.
		artefact triggerEvent: #changed.
		self allBlocksDo: [:block | block artefactChanged: artefact]]