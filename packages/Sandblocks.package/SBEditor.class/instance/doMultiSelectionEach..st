actions
doMultiSelectionEach: aBlock

	self doMultiSelection: [:sel | SBCombinedCommand newWith: (sel collect: aBlock)]