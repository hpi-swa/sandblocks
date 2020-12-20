printing
selectRightMostBlock
	<multiSelectAction>
	<inputAction>

	self containingStatement ifNil: [self rightMostBlock select] ifNotNil: [:statement | statement rightMostBlock select].
	
	self sandblockEditor maybeStartInputFromEnd