actions
selectPrevious
	<multiSelectAction>
	<inputAction>

	self sandblockEditor selectionDownHistory removeAll.
	self class navigation previousFrom: self do: [:b | (self canJumpTo: b) ifTrue: [b select]].
	
	self sandblockEditor maybeStartInputFromEnd