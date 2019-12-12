actions
deleteAroundSelection

	(self selection isExpression and: [self selection parentSandblock isExpression]) ifTrue: [
		self do: ((SBReplaceCommand newFor: self method)
			target: self selection parentSandblock;
			replacer: self selection)]