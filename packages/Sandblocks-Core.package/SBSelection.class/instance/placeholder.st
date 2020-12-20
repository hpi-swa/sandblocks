as yet unclassified
placeholder

	self allMorphsDo: [:m | (m isKindOf: SBPastePlaceholder) ifTrue: [^ m]].
	^ nil