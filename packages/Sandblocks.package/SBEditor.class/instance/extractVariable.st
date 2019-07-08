actions
extractVariable

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBBinding new name: name.
	block := self selection containingBlock.
	
	self do: (SBCombinedCommand new
		commands: {
			block declareTemporaryVariableCommand: name.
			SBReplaceCommand new target: self selection; replacer: var.
			SBInsertCommand new container: block; index: 3; morph: self selection.
			SBWrapCommand new inner: self selection; outer: SBAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})