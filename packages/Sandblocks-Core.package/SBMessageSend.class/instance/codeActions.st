accessing
codeActions

	^ super codeActions,
	
	(self isSendToSelf ifTrue: [{SBCodeAction labeled: 'Rename method' for: self do: #renameMethod}] ifFalse: [#()]),
	
	(self signature isUnary ifTrue: [{SBCodeAction labeled: 'Use as variable' for: self do: #useAsVariable}] ifFalse: [#()]),
	
	(SBSubstitution allSubclasses
		select: [:substition | substition matches: self]
		thenCollect: [:substitution | SBCodeAction labeled: 'Convert to ', substitution name for: self do: [:node |
			node sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: node;
				replacer: ((substitution newFrom: self) pc: self pc))]])