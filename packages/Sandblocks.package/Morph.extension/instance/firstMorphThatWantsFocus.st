*Sandblocks
firstMorphThatWantsFocus

	self allMorphsDo: [:m | m wantsKeyboardFocus ifTrue: [^ m]].
	^ nil