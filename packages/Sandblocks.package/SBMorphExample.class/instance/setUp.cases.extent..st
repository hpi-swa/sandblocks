as yet unclassified
setUp: aBlock cases: aCollectionOfBlocks extent: aPoint

	self addMorph: (setUp := aBlock statements first).
	
	aCollectionOfBlocks do: [:m | self addCase: m arguments second name: m arguments first contents].
	
	view extent: aPoint