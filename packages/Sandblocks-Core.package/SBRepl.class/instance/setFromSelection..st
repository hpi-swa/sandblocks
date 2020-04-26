artefact protocol
setFromSelection: aSelectionBlock

	aSelectionBlock childSandblocksDo: [:block |
		self body
			removeAllMorphs;
			addMorphBack: block]