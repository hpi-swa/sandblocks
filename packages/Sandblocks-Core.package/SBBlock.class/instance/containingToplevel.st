actions
containingToplevel
	" first parent that is floating "
	
	^ self floating ifTrue: [self] ifFalse: [self parentSandblock containingToplevel]