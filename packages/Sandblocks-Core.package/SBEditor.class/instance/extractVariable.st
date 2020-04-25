actions
extractVariable

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBName contents: name.
	block := self selection containingBlock.
	
	self do: (SBCombinedCommand newWith: {
			block declareTemporaryVariableCommand: name.
			(SBReplaceCommand newFor: self method) target: self selection; replacer: var.
			(SBInsertCommand newFor: self method) container: block; index: 2; morph: self selection.
			(SBWrapCommand newFor: self method) inner: self selection; outer: SBAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})