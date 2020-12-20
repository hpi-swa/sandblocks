actions
leftRotate
	<action>

	self hasChildSandblocks ifFalse: [^ self].
	(self isFirstChild or: [self isLastChild]) ifFalse: [^ self].
	
	self sandblockEditor do: ((SBSubtreeRotateCommand newFor: self containingArtefact)
		target: self;
		yourself)