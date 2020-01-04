selection
leftRotate

	(self selection isFirstChild or: [self selection isLastChild]) ifFalse: [^ self].
	self do: ((SBSubtreeRotateCommand newFor: self method)
		 target: self selection;
		 yourself)