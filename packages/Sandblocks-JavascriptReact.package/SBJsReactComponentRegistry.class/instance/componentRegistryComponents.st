accessing
componentRegistryComponents

	| allReplacementComponents |
	allReplacementComponents := OrderedCollection new.
	self componentRegistry keysAndValuesDo: [:categoryName :jsxElementReplacementsDict | allReplacementComponents addAll: jsxElementReplacementsDict associations].
	^ allReplacementComponents