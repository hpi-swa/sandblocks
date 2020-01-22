selection
batchedChangeStep

	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "
	compileTime = #compileOnChange ifTrue: [ | artefact |
		self saveTryFixing: false quick: true.
		artefact := self selectedArtefact.
		self allBlocksDo: [:block | block artefactChanged: artefact]]