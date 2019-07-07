actions
doMultiSelectionEach: aBlock

	self doMultiSelection: [:sel | SBCombinedCommand new commands: (sel collect: aBlock)]