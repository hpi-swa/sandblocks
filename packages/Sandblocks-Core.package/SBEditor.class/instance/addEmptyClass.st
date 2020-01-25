actions
addEmptyClass

	| class |
	class := SBClass new category: (self anyNearbyClass ifNotNil: #category ifNil: ['UserObjects']).
	self openMorphInView: class.
	self startInput: class childSandblocks first at: 1 replacingContents: false