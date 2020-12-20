actions
extractVariable
	<action>

	| name var block |
	name := (UIManager default request: 'Name for variable?') ifEmpty: [^ self].
	var := SBName contents: name.
	block := self containingBlock.
	
	self sandblockEditor do: (SBCombinedCommand newWith: {
			block declareTemporaryVariableCommand: name.
			(SBReplaceCommand newFor: self containingArtefact) target: self; replacer: var.
			(SBInsertCommand newFor: self containingArtefact) container: block; index: 2; morph: self.
			(SBWrapCommand newFor: self containingArtefact) inner: self; outer: SBAssignment new; wrap: [:outer :inner | outer binding: var veryDeepCopy value: inner].
		})