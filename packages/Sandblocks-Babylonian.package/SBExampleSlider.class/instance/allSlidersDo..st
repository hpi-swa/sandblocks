as yet unclassified
allSlidersDo: aBlock

	self sandblockEditor allBlocksDo: [:block |
		(block isKindOf: SBExampleBlockDecoration) ifTrue: [aBlock value: block]]