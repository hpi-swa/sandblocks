artefact protocol
setFromSelection: aSelectionBlock

	self body removeAllMorphs.
	aSelectionBlock childSandblocksDo: [:block |
		self body addMorphBack: block]