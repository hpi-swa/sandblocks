actions
selectNext
	<multiSelectAction>
	<inputAction>

	self sandblockEditor selectionDownHistory removeAll.
	self class navigation nextFrom: self do: [:b | (self canJumpTo: b) ifTrue: [b select]].
	
	self sandblockEditor maybeStartInputFromStart