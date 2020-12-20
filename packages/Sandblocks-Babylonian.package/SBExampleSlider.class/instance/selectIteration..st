as yet unclassified
selectIteration: aNumber

	selectedIndex = aNumber ifTrue: [^ self].
	selectedIndex := aNumber.
	
	self firstSubmorph contents: (aNumber asString, '/'), contextIdentityHashes size asString.
	
	(aNumber > 0 and: [contextIdentityHashes notEmpty]) ifTrue: [
		self allWatchesDo: [:watch |
			watch filterForContextId: (contextIdentityHashes at: aNumber) example: example].
		self allSlidersDo: [:slider |
			slider filterForContextId: (contextIdentityHashes at: aNumber) example: example]]